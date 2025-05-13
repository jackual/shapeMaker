//
//  SpatialChord.swift
//  shapeMaker
//
//  Created by Jack Brodie on 13/05/2025.
//

struct SpatialChord {
    let notes: [SpatialNote]
    init (_ notes: [Int]) {
        self.notes = notes.map { SpatialNote(Float($0)) }
    }
}

struct SpatialNote {
    let yPosition: Float
    init (_ relNoteNumber: Float) {
        let normalised = relNoteNumber.normalise(0...27)
        let low: Float = 1.15
        let high: Float = 2.15
        self.yPosition = low + normalised * (high - low)
    }
}

extension Float {
    func normalise(_ range: ClosedRange<Float>) -> Float {
        return max(0, min(1, (self - range.lowerBound) / (range.upperBound - range.lowerBound)))
    }
}
