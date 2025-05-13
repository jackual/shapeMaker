//
//  ImmersiveView.swift
//  shapeMaker
//
//  Created by Jack Brodie on 12/05/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct sphereMaker {
    public let anchor = AnchorEntity()
    
    init() {
        let sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.1),
            materials: [SimpleMaterial(
                color: .systemBlue,
                roughness: 0.1,
                isMetallic: true
                
            )]
        )
        anchor.position = SIMD3(x: 0, y: 2, z: -1)
        anchor.addChild(sphere)
    }
    
    func move(_ translation: SIMD3<Float>) {
        let targetTransform = Transform(
            scale: SIMD3<Float>(x: 1, y: 1, z: 1),
            rotation: simd_quaternion(0, 0, 0, 1),
            translation: translation
        )
        anchor.move(to: targetTransform, relativeTo: nil, duration: 0.2)
    }
}

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        RealityView { content in
            let sphere = sphereMaker()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                sphere.move(SIMD3<Float>(x: 0, y: 2, z: -1.2))
            }
            content.add(sphere.anchor)
        }
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}
