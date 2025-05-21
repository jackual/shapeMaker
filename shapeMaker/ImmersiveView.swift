//
//  ImmersiveView.swift
//  shapeMaker
//
//  Created by Jack Brodie on 12/05/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Tonic
import HandSynthLibrary

extension Pattern {
    func toSpatialChords() -> [SpatialChord] {
        var spatialChords: [SpatialChord] = []
        for chordNotes in patternNotes {
            var spatialIndices: [Int] = []
            for chordNote in chordNotes {
                guard let degreeIndex = key.noteSet.array.firstIndex(where: { $0.noteClass == chordNote.note.noteClass }) else {
                    fatalError("Note \(chordNote.note) is not in the key's scale")
                }
                // Clamp octave to 4 octaves from base octave
                let octave = min(max(chordNote.octave, baseOctave), baseOctave + 3)
                // Map the scale degree and octave to a spatial index (7 notes per octave)
                let spatialIndex = (octave - baseOctave) * 7 + degreeIndex
                spatialIndices.append(spatialIndex)
            }
            spatialIndices.sort()
            spatialChords.append(SpatialChord(spatialIndices))
        }
        return spatialChords
    }
}

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    @State private var clusters: [Cluster] = []
    
    var body: some View {
        RealityView { content in
            let spatialChord1 = samplePatch.pattern.toSpatialChords()[7]
            let spatialChord2 = samplePatch.pattern.toSpatialChords()[2]
            var cluster1 = await Cluster(
                x: 0.0,
                z: -0.4,
                patch: samplePatch,
                content: content,
                name: "a"
            )
            clusters.append(contentsOf: [cluster1])
            //await cluster1.updateChord(spatialChord2)
            
        }
        //        } update: { content in
        //            // Update hover states for all clusters
        //            for i in clusters.indices {
        //                clusters[i].checkHover()
        //            }
        //        }
    }
}
//
//#Preview(immersionStyle: .progressive) {
//    ImmersiveView()
//        .environment(AppModel())
//}
