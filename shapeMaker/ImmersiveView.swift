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
    
    var body: some View {
        RealityView { content in
            let spatialChord = SpatialChord([
                0, 8, 7, 12, 27
            ])
            
            let clusterPositions = [
                (x: 0.0 as Float, z: -1.0 as Float),
                (x: 0.3 as Float, z: -1.0 as Float),
                (x: -0.5 as Float, z: -1.0 as Float)
            ]
            
            for position in clusterPositions {
                var cluster = Cluster(
                    x: position.x,
                    z: position.z,
                    spatialChord: spatialChord,
                    content: content
                )
                 
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    cluster.updateChord(SpatialChord([1, 8, 10, 18, 5, 27, 22]))
                }
            }
        }
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}
