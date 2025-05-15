//
//  Cluster.swift
//  shapeMaker
//
//  Created by Jack Brodie on 13/05/2025.
//
import RealityKit
import RealityKitContent
import SwiftUI

struct Cluster {
    struct SphereState {
        let position: SIMD3<Float>
        let id: UUID
    }
    
    let name: String
    private var isHovered = false
    private var sphereStates: [SphereState]
    private var sphereEntities: [UUID: Orb] = [:]
    private var chord: SpatialChord
    private let content: RealityViewContent
    
    init(
        x: Float, z: Float,
        spatialChord: SpatialChord,
        content: RealityViewContent,
        name: String
    ) {
        self.name = name
        self.content = content
        self.chord = spatialChord
        
        // Initialize sphere states
        sphereStates = spatialChord.notes.map { note in
            let offset: ClosedRange<Float> = -0.03...0.03
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
        
        // Create initial spheres
        for state in sphereStates {
            let sphere = Orb(state.position, colour: .red)
            content.add(sphere.anchor)
            sphereEntities[state.id] = sphere
        }
    }
    
    mutating func updateChord(_ spatialChord: SpatialChord) {
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
        
        // Apply changes to entities
        for id in toRemove {
            if let sphere = sphereEntities[id] {
                sphere.kill()
                sphereEntities.removeValue(forKey: id)
            }
        }
        
        for (id, newPos) in toMove {
            sphereEntities[id]?.move(newPos)
        }
        
        for state in toAdd {
            let sphere = Orb(state.position)
            content.add(sphere.anchor)
            sphereEntities[state.id] = sphere
        }
    }
    
    mutating func checkHover() {
        print("Cluster '\(name)' checking hover state...")
        print("Number of spheres: \(sphereEntities.count)")
        
        let newHoverState = sphereEntities.values.contains { orb in
            let isHovering = orb.checkHover()
            print("Orb hover check returned: \(isHovering)")
            return isHovering
        }
        
        print("Cluster '\(name)' hover state: \(newHoverState) (was: \(isHovered))")
        if newHoverState != isHovered {
            isHovered = newHoverState
            if isHovered {
                print("Now hovering over cluster: \(name)")
            } else {
                print("No longer hovering over cluster: \(name)")
            }
        }
    }
}
