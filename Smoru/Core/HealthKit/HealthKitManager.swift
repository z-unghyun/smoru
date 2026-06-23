import Foundation
import HealthKit

final class HealthKitManager: HealthKitManaging {
    private let healthStore = HKHealthStore()
    private let calendar = Calendar.current

    func isHealthDataAvailable() -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() async -> HealthKitAuthorizationResult {
        guard isHealthDataAvailable() else {
            return .unavailable
        }

        let types = requiredReadTypes()
        do {
            try await healthStore.requestAuthorization(toShare: [], read: types)
        } catch {
            return .denied
        }

        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        let status = sleepType.map { healthStore.authorizationStatus(for: $0) } ?? .sharingDenied
        return status == .sharingAuthorized ? .authorized : .denied
    }

    func fetchRecentSleepSummary() async -> HealthKitFetchResult {
        guard isHealthDataAvailable() else {
            return .unavailable
        }

        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        if let sleepType {
            let status = healthStore.authorizationStatus(for: sleepType)
            if status != .sharingAuthorized {
                return .denied
            }
        }

        guard let session = await fetchRecentMainSleepSession() else {
            return .noData
        }

        async let heartRate = fetchAverageQuantity(.heartRate, unit: HKUnit(from: "count/min"), start: session.startDate, end: session.endDate)
        async let hrv = fetchAverageQuantity(.heartRateVariabilitySDNN, unit: HKUnit.secondUnit(with: .milli), start: session.startDate, end: session.endDate)
        async let respiratory = fetchAverageQuantity(.respiratoryRate, unit: HKUnit(from: "count/min"), start: session.startDate, end: session.endDate)
        async let stepCount = fetchSumQuantity(.stepCount, unit: HKUnit.count(), start: session.startDate, end: session.endDate)

        let heartRateValue = await heartRate
        let hrvValue = await hrv
        let respiratoryValue = await respiratory
        let stepValue = await stepCount

        let qualitySignals = [heartRateValue, hrvValue, respiratoryValue, stepValue].compactMap { $0 }
        let qualityScore = max(40.0, (Double(qualitySignals.count) / 4.0) * 100.0)

        let summary = DailySleepSummaryData(
            date: session.endDate,
            source: .healthKit,
            totalSleepMinutes: session.totalSleepMinutes,
            awakeMinutes: session.awakeMinutes,
            wakeCount: session.wakeCount,
            sleepEfficiency: session.sleepEfficiency,
            averageHeartRate: heartRateValue ?? 0,
            hrvSDNN: hrvValue ?? 0,
            respiratoryRate: respiratoryValue ?? 0,
            stepCount: stepValue ?? 0,
            dataQualityScore: qualityScore
        )

        return .success(summary)
    }

    private func requiredReadTypes() -> Set<HKObjectType> {
        var types: Set<HKObjectType> = []

        if let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            types.insert(sleep)
        }
        if let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) {
            types.insert(heartRate)
        }
        if let hrv = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) {
            types.insert(hrv)
        }
        if let respiratory = HKObjectType.quantityType(forIdentifier: .respiratoryRate) {
            types.insert(respiratory)
        }
        if let steps = HKObjectType.quantityType(forIdentifier: .stepCount) {
            types.insert(steps)
        }

        return types
    }

    private func fetchRecentMainSleepSession() async -> SleepSessionSummary? {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return nil
        }

        let now = Date()
        let start = calendar.date(byAdding: .day, value: -2, to: now) ?? now.addingTimeInterval(-172_800)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: now, options: [.strictStartDate, .strictEndDate])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let samples = await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: sleepType,
                predicate: predicate,
                limit: 200,
                sortDescriptors: [sortDescriptor]
            ) { _, results, _ in
                continuation.resume(returning: (results as? [HKCategorySample]) ?? [])
            }
            healthStore.execute(query)
        }

        let asleepValues: Set<Int> = [
            HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
            HKCategoryValueSleepAnalysis.asleepCore.rawValue,
            HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
            HKCategoryValueSleepAnalysis.asleepREM.rawValue
        ]

        let asleepSamples = samples.filter { asleepValues.contains($0.value) }
        guard !asleepSamples.isEmpty else { return nil }

        let groupedByMorning = Dictionary(grouping: asleepSamples) { sample in
            morningBoundary(for: sample.endDate)
        }

        guard let bestGroup = groupedByMorning.values
            .max(by: { totalDuration(of: $0) < totalDuration(of: $1) }) else {
            return nil
        }

        let startDate = bestGroup.map { $0.startDate }.min() ?? now
        let endDate = bestGroup.map { $0.endDate }.max() ?? now
        let totalSleepMinutes = totalDuration(of: bestGroup) / 60.0

        let awakeSamples = samples.filter { $0.value == HKCategoryValueSleepAnalysis.awake.rawValue }
            .filter { $0.startDate >= startDate && $0.endDate <= endDate }

        let awakeMinutes = totalDuration(of: awakeSamples) / 60.0
        let wakeCount = awakeSamples.count
        let effectiveMinutes = max(totalSleepMinutes + awakeMinutes, 1)
        let sleepEfficiency = min(max(totalSleepMinutes / effectiveMinutes, 0), 1)

        return SleepSessionSummary(
            startDate: startDate,
            endDate: endDate,
            totalSleepMinutes: totalSleepMinutes,
            awakeMinutes: awakeMinutes,
            wakeCount: wakeCount,
            sleepEfficiency: sleepEfficiency
        )
    }

    private func totalDuration(of samples: [HKSample]) -> Double {
        samples.reduce(0) { partial, sample in
            partial + sample.endDate.timeIntervalSince(sample.startDate)
        }
    }

    private func morningBoundary(for date: Date) -> Date {
        let start = calendar.startOfDay(for: date)
        return calendar.date(byAdding: .hour, value: 6, to: start) ?? start
    }

    private func fetchAverageQuantity(_ identifier: HKQuantityTypeIdentifier, unit: HKUnit, start: Date, end: Date) async -> Double? {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
            return nil
        }

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .discreteAverage) { _, statistics, _ in
                guard let value = statistics?.averageQuantity()?.doubleValue(for: unit) else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }

    private func fetchSumQuantity(_ identifier: HKQuantityTypeIdentifier, unit: HKUnit, start: Date, end: Date) async -> Double? {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
            return nil
        }

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, _ in
                guard let value = statistics?.sumQuantity()?.doubleValue(for: unit) else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }
}

private struct SleepSessionSummary {
    var startDate: Date
    var endDate: Date
    var totalSleepMinutes: Double
    var awakeMinutes: Double
    var wakeCount: Int
    var sleepEfficiency: Double
}
