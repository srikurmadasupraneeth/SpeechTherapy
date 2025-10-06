import Foundation
import ARKit
import Vision

public protocol FaceTrackingService: AnyObject {
    var onMetrics: (([String: Double]) -> Void)? { get set }
    func start() async throws
    func stop()
}

public final class ARKitFaceTrackingService: NSObject, FaceTrackingService, ARSessionDelegate {
    private let session = ARSession()
    public var onMetrics: (([String: Double]) -> Void)?
    public override init() { super.init() }

    public func start() async throws {
        guard ARFaceTrackingConfiguration.isSupported else {
            throw NSError(domain: "FaceTracking", code: -1, userInfo: [NSLocalizedDescriptionKey: "ARKit face tracking not supported"])
        }
        session.delegate = self
        let config = ARFaceTrackingConfiguration()
        config.isLightEstimationEnabled = false
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    public func stop() {
        session.pause()
    }

    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let faceAnchor = anchor as? ARFaceAnchor else { continue }
            let bs = faceAnchor.blendShapes
            var metrics: [String: Double] = [:]
            metrics["jawOpen"] = (bs[.jawOpen]?.doubleValue) ?? 0
            metrics["mouthFunnel"] = (bs[.mouthFunnel]?.doubleValue) ?? 0
            metrics["mouthPucker"] = (bs[.mouthPucker]?.doubleValue) ?? 0
            metrics["cheekPuff"] = (bs[.cheekPuff]?.doubleValue) ?? 0
            metrics["tongueOut"] = (bs[.tongueOut]?.doubleValue) ?? 0
            onMetrics?(metrics)
        }
    }
}
