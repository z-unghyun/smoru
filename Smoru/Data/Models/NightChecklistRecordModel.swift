import Foundation
import SwiftData

@Model
final class NightChecklistRecordModel {
    var id: UUID
    var date: Date
    var checkedCount: Int
    var totalCount: Int
    var completionRatio: Double

    init(
        id: UUID = UUID(),
        date: Date,
        checkedCount: Int,
        totalCount: Int
    ) {
        self.id = id
        self.date = date
        self.checkedCount = checkedCount
        self.totalCount = totalCount
        self.completionRatio = totalCount == 0 ? 0 : Double(checkedCount) / Double(totalCount)
    }
}
