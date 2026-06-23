import Foundation
import SwiftData

@Model
final class StageBootstrapModel {
    var createdAt: Date

    init(createdAt: Date = .now) {
        self.createdAt = createdAt
    }
}
