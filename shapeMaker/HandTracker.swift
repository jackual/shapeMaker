import RealityKit
import ARKit

@MainActor
class HandTracker {
    private var arSession = ARKitSession()
    private let handTracking = HandTrackingProvider()
    private var latestLeftHand: HandAnchor?
    private var latestRightHand: HandAnchor?
    
    func startTracking() async {
        do {
            
            // Start collecting hand tracking updates
            for await update in handTracking.anchorUpdates {
                switch update.anchor.chirality {
                case .left:
                    latestLeftHand = update.anchor
                case .right:
                    latestRightHand = update.anchor
                default:
                    break
                }
                
                processHandData(update.anchor)
            }
        } catch {
            print("Failed to initialize hand tracking: \(error)")
        }
    }
    
    private func processHandData(_ handAnchor: HandAnchor) {
        // Get hand height
        let handTransform = handAnchor.originFromAnchorTransform
        let handHeight = handTransform.columns.3.y
        let handType = handAnchor.chirality == .left ? "Left" : "Right"
        
        // Get pinch distance
        if let handSkeleton = handAnchor.handSkeleton {
            let indexTipTransform = handSkeleton.joint(.indexFingerTip).anchorFromJointTransform
            let thumbTipTransform = handSkeleton.joint(.thumbTip).anchorFromJointTransform
            
            let indexTipPosition = indexTipTransform.columns.3
            let thumbTipPosition = thumbTipTransform.columns.3
            
            let pinchDistance = distance(indexTipPosition, thumbTipPosition)
            let normalizedPinch = pinchDistance.normalise(0.07...0.15)
            
            print("\(handType) Hand - Height: \(handHeight), Pinch: \(floor(normalizedPinch * 100))%")
        }
    }
}
    

private func distance(_ a: SIMD4<Float>, _ b: SIMD4<Float>) -> Float {
    let diff = a - b
    return sqrt(diff.x * diff.x + diff.y * diff.y + diff.z * diff.z)
}
