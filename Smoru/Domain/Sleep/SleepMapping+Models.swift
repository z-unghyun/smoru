import Foundation

extension DailySleepSummaryModel {
    var asDomainData: DailySleepSummaryData {
        DailySleepSummaryData(
            date: date,
            source: source,
            totalSleepMinutes: totalSleepMinutes,
            awakeMinutes: awakeMinutes,
            wakeCount: wakeCount,
            sleepEfficiency: sleepEfficiency,
            averageHeartRate: averageHeartRate,
            hrvSDNN: hrvSDNN,
            respiratoryRate: respiratoryRate,
            stepCount: stepCount,
            dataQualityScore: dataQualityScore
        )
    }
}
