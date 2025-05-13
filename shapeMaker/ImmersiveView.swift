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
    
    init(_ position: SIMD3<Float>) {
        let sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.03),
            materials: [SimpleMaterial(
                color: .systemBlue,
                roughness: 0.2,
                isMetallic: true
                
            )]
        )
        anchor.position = position
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

struct Cluster {
    let spheres: [sphereMaker]
    
    init(position: SIMD3<Float>) {
        spheres = (0..<5).map { index in
            let yOffset = Float(index) * 0.1
            let offset: ClosedRange<Float> = -0.05...0.05
            let xOffset = Float.random(in: offset)
            let zOffset = Float.random(in: offset)
            let spherePosition = SIMD3(
                x: position.x + xOffset,
                y: position.y + yOffset,
                z: position.z + zOffset
            )
            return sphereMaker(spherePosition)
        }
    }
}

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        RealityView { content in
            let positions = [
                SIMD3<Float>(x: 0.0, y: 1.7, z: -1.0),
                SIMD3<Float>(x: 0.3, y: 1.7, z: -1.0),
                SIMD3<Float>(x: -0.5, y: 1.2, z: -1)
            ]
            for position in positions {
                let cluster = Cluster(position: position)
                for sphere in cluster.spheres {
                    content.add(sphere.anchor)
                }
            }
        }
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}
