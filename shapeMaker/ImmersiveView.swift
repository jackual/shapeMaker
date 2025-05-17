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
            let spatialChord1 = samplePatch.pattern.toSpatialChords()[0]
            //            let spatialChord2 = SpatialChord([3, 6, 9, 15, 21])
            //            let spatialChord3 = SpatialChord([2, 4, 11, 16, 23])
            
            var cluster1 = Cluster(
                x: 0.0,
                z: -0.4,
                spatialChord: spatialChord1,
                content: content,
                name: "a"
            )
            //
            //            var cluster2 = Cluster(
            //                x: 0.3,
            //                z: -0.6,
            //                spatialChord: spatialChord2,
            //                content: content,
            //                name: "b"
            //            )
            //
            //            var cluster3 = Cluster(
            //                x: -0.5,
            //                z: -1.0,
            //                spatialChord: spatialChord3,
            //                content: content,
            //                name: "cs"
            //            )
            //
            clusters.append(contentsOf: [cluster1/*, cluster2, cluster3*/])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                //                cluster1.updateChord(SpatialChord([1, 8, 10, 18, 5]))
                //                cluster2.updateChord(SpatialChord([0, 5, 13, 17, 25]))
                //                cluster3.updateChord(SpatialChord([4, 6, 12, 20, 22]))
            }
        } update: { content in
            // Update hover states for all clusters
            for i in clusters.indices {
                clusters[i].checkHover()
            }
        }
    }
}
//
//#Preview(immersionStyle: .progressive) {
//    ImmersiveView()
//        .environment(AppModel())
//}
