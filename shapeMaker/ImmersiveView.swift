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
    
    /// Removes this orb from the scene
    func kill() {
        anchor.removeFromParent()
    }
}

struct Cluster {
    struct SphereState {
        let position: SIMD3<Float>
        let id: UUID
    }
    
    var sphereStates: [SphereState]
    private var chord: SpatialChord
    
    init(x: Float, z: Float, spatialChord: SpatialChord) {
        chord = spatialChord
        sphereStates = spatialChord.notes.map { note in
            let offset: ClosedRange<Float> = -0.05...0.05
            let xOffset = Float.random(in: offset)
            let zOffset = Float.random(in: offset)
            return SphereState(
                position: SIMD3(
                    x: x + xOffset,
                    y: note.yPosition,
                    z: z + zOffset
                ),
                id: UUID()
            )
        }
    }
    
    mutating func updateChord(_ spatialChord: SpatialChord) -> (
        toAdd: [SphereState],
        toRemove: [UUID],
        toMove: [(id: UUID, newPosition: SIMD3<Float>)]
    ) {
        let sortedStates = sphereStates.sorted { $0.position.y < $1.position.y }
        let sortedTargetY = spatialChord.notes.map(\.yPosition).sorted()
        
        var toAdd: [SphereState] = []
        var toRemove: [UUID] = []
        var toMove: [(UUID, SIMD3<Float>)] = []
        
        // Handle moves for existing spheres
        let commonCount = min(sortedStates.count, sortedTargetY.count)
        for i in 0..<commonCount {
            let state = sortedStates[i]
            let newPos = SIMD3<Float>(
                x: state.position.x,
                y: sortedTargetY[i],
                z: state.position.z
            )
            toMove.append((state.id, newPos))
        }
        
        // Handle removals
        if sortedTargetY.count < sortedStates.count {
            toRemove = Array(sortedStates[sortedTargetY.count...].map(\.id))
        }
        
        // Handle additions
        if sortedTargetY.count > sortedStates.count {
            for i in sortedStates.count..<sortedTargetY.count {
                let newState = SphereState(
                    position: SIMD3(
                        x: sortedStates[0].position.x + Float.random(in: -0.05...0.05),
                        y: sortedTargetY[i],
                        z: sortedStates[0].position.z + Float.random(in: -0.05...0.05)
                    ),
                    id: UUID()
                )
                toAdd.append(newState)
            }
        }
        
        // Update internal state
        sphereStates = (sphereStates.filter { !toRemove.contains($0.id) } + toAdd)
            .map { state in
                if let moveInfo = toMove.first(where: { $0.0 == state.id }) {
                    return SphereState(position: moveInfo.1, id: state.id)
                }
                return state
            }
        chord = spatialChord
        
        return (toAdd, toRemove, toMove)
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

struct ClusterManager {
    private var cluster: Cluster
    private var sphereEntities: [UUID: Orb] = [:]
    private let content: RealityViewContent
    
    init(x: Float, z: Float, spatialChord: SpatialChord, content: RealityViewContent) {
        self.content = content
        self.cluster = Cluster(x: x, z: z, spatialChord: spatialChord)
        
        // Create initial spheres
        for state in cluster.sphereStates {
            let sphere = Orb(state.position)
            content.add(sphere.anchor)
            sphereEntities[state.id] = sphere
        }
    }
    
    mutating func updateChord(_ spatialChord: SpatialChord) {
        let changes = cluster.updateChord(spatialChord)
        
        // Handle removals
        for id in changes.toRemove {
            if let sphere = sphereEntities[id] {
                sphere.kill()
                sphereEntities.removeValue(forKey: id)
            }
        }
        
        // Handle moves
        for (id, newPos) in changes.toMove {
            sphereEntities[id]?.move(newPos)
        }
        
        // Handle additions
        for state in changes.toAdd {
            let sphere = Orb(state.position)
            content.add(sphere.anchor)
            sphereEntities[state.id] = sphere
        }
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
                var manager = ClusterManager(
                    x: position.x,
                    z: position.z,
                    spatialChord: spatialChord,
                    content: content
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    manager.updateChord(SpatialChord([0, 8, 7, 12, 26, 27]))
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
