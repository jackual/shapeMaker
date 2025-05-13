//
//  ImmersiveView.swift
//  shapeMaker
//
//  Created by Jack Brodie on 12/05/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Orb {
    public let anchor = AnchorEntity()
    
    init(_ position: SIMD3<Float>, radius: Float = 16) {
        let sphere = ModelEntity(
            mesh: .generateSphere(radius: radius / 1000),
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
    let spheres: [Orb]
    
    init(x: Float, z: Float, spatialChord: SpatialChord) {
        spheres = spatialChord.notes.map { note in
            let offset: ClosedRange<Float> = -0.05...0.05
            let xOffset = Float.random(in: offset)
            let zOffset = Float.random(in: offset)
            let spherePosition = SIMD3(
                x: x + xOffset,
                y: note.yPosition,
                z: z + zOffset
            )
            return Orb(spherePosition)
        }
    }
}

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
                let cluster = Cluster(x: position.x, z: position.z, spatialChord: spatialChord)
                for sphere in cluster.spheres {
                    content.add(sphere.anchor)
                }
            }
        }
    }
}

extension Float {
    func normalise(_ range: ClosedRange<Float>) -> Float {
        return max(0, min(1, (self - range.lowerBound) / (range.upperBound - range.lowerBound)))
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}
