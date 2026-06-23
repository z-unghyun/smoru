import Foundation
import SwiftData

@Model
final class DailySleepSummaryModel {
    var id: UUID
    var date: Date
    var sourceRawValue: String
    var totalSleepMinutes: Double
    var awakeMinutes: Double
    var wakeCount: Int
    var sleepEfficiency: Double
    var averageHeartRate: Double
    var hrvSDNN: Double
    var respiratoryRate: Double
    var stepCount: Double
    var dataQualityScore: Double
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        date: Date,
        source: SleepDataSource,
        totalSleepMinutes: Double,
        awakeMinutes: Double,
        wakeCount: Int,
        sleepEfficiency: Double,
        averageHeartRate: Double,
        hrvSDNN: Double,
        respiratoryRate: Double,
        stepCount: Double,
        dataQualityScore: Double,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.date = date
        self.sourceRawValue = source.rawValue
        self.totalSleepMinutes = totalSleepMinutes
        self.awakeMinutes = awakeMinutes
        self.wakeCount = wakeCount
        self.sleepEfficiency = sleepEfficiency
        self.averageHeartRate = averageHeartRate
        self.hrvSDNN = hrvSDNN
        self.respiratoryRate = respiratoryRate
        self.stepCount = stepCount
        self.dataQualityScore = dataQualityScore
        self.updatedAt = updatedAt
    }

    var source: SleepDataSource {
        get { SleepDataSource(rawValue: sourceRawValue) ?? .sample }
        set { sourceRawValue = newValue.rawValue }
    }
}
