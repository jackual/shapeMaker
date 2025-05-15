//
//  ImmersiveView.swift
//  shapeMaker
//
//  Created by Jack Brodie on 12/05/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    @State private var clusters: [Cluster] = []
    
    var body: some View {
        RealityView { content in
            let spatialChord1 = SpatialChord([0, 8, 7, 12, 27])
            let spatialChord2 = SpatialChord([3, 6, 9, 15, 21])
            let spatialChord3 = SpatialChord([2, 4, 11, 16, 23])
            
            var cluster1 = Cluster(
                x: 0.0,
                z: -0.4,
                spatialChord: spatialChord1,
                content: content,
                name: "a"
            )
            
            var cluster2 = Cluster(
                x: 0.3,
                z: -0.6,
                spatialChord: spatialChord2,
                content: content,
                name: "b"
            )
            
            var cluster3 = Cluster(
                x: -0.5,
                z: -1.0,
                spatialChord: spatialChord3,
                content: content,
                name: "cs"
            )
            
            clusters.append(contentsOf: [cluster1, cluster2, cluster3])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                cluster1.updateChord(SpatialChord([1, 8, 10, 18, 5]))
                cluster2.updateChord(SpatialChord([0, 5, 13, 17, 25]))
                cluster3.updateChord(SpatialChord([4, 6, 12, 20, 22]))
            }
        } update: { content in
            // Update hover states for all clusters
            for i in clusters.indices {
                clusters[i].checkHover()
            }
        }
    }
} 

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}
