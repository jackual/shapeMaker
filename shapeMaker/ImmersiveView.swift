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
//            let ambientLight = Entity()
//            ambientLight.components[PointLightComponent.self] = PointLightComponent(
//                color: .white,
//                intensity: 1000,
//                attenuationRadius: 4.0
//            )
//            ambientLight.position = SIMD3(x: 0, y: 2, z: -1)
            
            // Create a sphere with material that's more visible
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(
                    color: .systemBlue,
                    roughness: 0.1,
                    isMetallic: true
                )]
            )
                        
            let anchor = AnchorEntity()
            anchor.position = SIMD3(x: 0, y: 2, z: -1)
            anchor.addChild(sphere)
            //anchor.addChild(ambientLight)
            content.add(anchor)
        }
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}
