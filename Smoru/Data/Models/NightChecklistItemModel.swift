import Foundation
import SwiftData

@Model
final class NightChecklistItemModel {
    var id: UUID
    var title: String
    var sortOrder: Int
    var isDefault: Bool

    init(
        id: UUID = UUID(),
        title: String,
        sortOrder: Int,
        isDefault: Bool = true
    ) {
        self.id = id
        self.title = title
        self.sortOrder = sortOrder
        self.isDefault = isDefault
    }
}
