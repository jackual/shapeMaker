//
//  Orb.swift
//  shapeMaker
//
//  Created by Jack Brodie on 13/05/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

@MainActor
class Orb {
    public let anchor = AnchorEntity()
    
    init(_ position: SIMD3<Float>, radius: Float = 0.035, colour: SimpleMaterial.Color = .systemBlue) async {
        print("Creating orb at position: \(position)")
        
        let sphere = ModelEntity(
            mesh: .generateSphere(radius: radius),
            materials: [SimpleMaterial(
                color: colour,
                roughness: 0.2,
                isMetallic: true
            )]
        )
        
        // Add hover effect
        sphere.components[HoverEffectComponent.self] = HoverEffectComponent()
        
        anchor.setScale(SIMD3<Float>(repeating: 0), relativeTo: nil)
        DispatchQueue.main.async { [anchor] in
            let targetTransform = Transform(
                scale: SIMD3<Float>(repeating: 1),
                rotation: anchor.transform.rotation,
                translation: anchor.transform.translation
            )
            anchor.move(to: targetTransform, relativeTo: nil, duration: 0.2)
        }
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
    
    func checkHover() -> Bool {
        print("Orb checking hover...")
        guard let sphere = anchor.children.first as? ModelEntity else {
            print("No sphere found")
            return false
        }
        let hasHoverComponent = sphere.components[HoverEffectComponent.self] != nil
        print("Sphere has hover component: \(hasHoverComponent)")
        return hasHoverComponent
    }
    
    /// Removes this orb from the scene
    func kill() {
        anchor.removeFromParent()
    }
}
