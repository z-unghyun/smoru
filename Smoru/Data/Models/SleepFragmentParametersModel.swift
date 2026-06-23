import Foundation
import SwiftData

@Model
final class SleepFragmentParametersModel {
    var id: UUID
    var date: Date
    var totalScore: Double
    var durationRatio: Double
    var edgeRoughness: Double
    var colorProgress: Double
    var symmetry: Double
    var innerGlow: Double
    var surfaceVibration: Double
    var roundness: Double
    var opacity: Double
    var sharpness: Double
    var seed: Int

    init(
        id: UUID = UUID(),
        date: Date,
        totalScore: Double,
        durationRatio: Double,
        edgeRoughness: Double,
        colorProgress: Double,
        symmetry: Double,
        innerGlow: Double,
        surfaceVibration: Double,
        roundness: Double,
        opacity: Double,
        sharpness: Double,
        seed: Int
    ) {
        self.id = id
        self.date = date
        self.totalScore = totalScore
        self.durationRatio = durationRatio
        self.edgeRoughness = edgeRoughness
        self.colorProgress = colorProgress
        self.symmetry = symmetry
        self.innerGlow = innerGlow
        self.surfaceVibration = surfaceVibration
        self.roundness = roundness
        self.opacity = opacity
        self.sharpness = sharpness
        self.seed = seed
    }
}
