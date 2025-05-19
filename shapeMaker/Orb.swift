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
    
    init(_ position: SIMD3<Float>, radius: Float = 0.016, colour: SimpleMaterial.Color = .systemBlue) async {
        print("Creating orb at position: \(position)")
        do {
            var material = try await ShaderGraphMaterial(named: "/Root/Clouds", from: "Materials", in: realityKitContentBundle)
            let sphere = ModelEntity(
                mesh: .generateSphere(radius: radius),
                materials: [material]
            )
            
            // Set initial scale to zero before adding to scene
            anchor.scale = .one
            anchor.position = position
            anchor.addChild(sphere)
            
        }
  catch {
            print("error")
        }
    }
    
    func customMove(_ translation: SIMD3<Float>, scale: Float = 1) {
        print(translation)
        let targetTransform = Transform(
            scale: SIMD3<Float>(x: scale, y: scale, z: scale),
            rotation: simd_quaternion(0, 0, 0, 1),
            translation: translation
        )
        anchor.move(to: targetTransform, relativeTo: nil, duration: 0.2)
    }
    func animateIn(duration: TimeInterval = 2) {
        print("animate in")
        
        // No need to set initial scale since it's already zero
        let target = Transform(
            scale: .one,
            rotation: anchor.transform.rotation,
            translation: anchor.transform.translation)
        
        // Animate to full scale
        anchor.move(to: target, relativeTo: nil, duration: duration)
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

