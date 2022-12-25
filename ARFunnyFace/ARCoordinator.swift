//
//  ARCoordinator.swift
//  ARFunnyFace
//
//  Created by Zaid Neurothrone on 2022-12-25.
//

import ARKit

final class ARCoordinator: NSObject {
  var arViewContainer: ARViewContainer
  
  var isLasersDone = true
  
  init(_ control: ARViewContainer) {
    arViewContainer = control
    super.init()
  }
  
  func deg2Rad(_ value: Float) -> Float {
    value * .pi / 180
  }
}

/*
 simd_quatf(angle:,axis:): Allows you to specify a single rotation by means of an angle amount along with the axis the rotation will revolve around.

 simd_mul(p:, q:): Lets you multiply two quaternions together to form a single quaternion. Use this function when you want to apply more than one rotation to an entity.
 */

extension ARCoordinator: ARSessionDelegate {
  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    // You’re only interested in anchor updates while the robot scene is active. When robot is nil, you simply skip any updates.
    guard robot != nil else { return }

    var faceAnchor: ARFaceAnchor?
    
    for anchor in anchors {
      if let a = anchor as? ARFaceAnchor {
        faceAnchor = a
      }
    }
    
    let blendShapes = faceAnchor?.blendShapes
    let eyeBlinkLeft = blendShapes?[.eyeBlinkLeft]?.floatValue
    let eyeBlinkRight = blendShapes?[.eyeBlinkRight]?.floatValue
    
    let browInnerUp = blendShapes?[.browInnerUp]?.floatValue
    let browLeft = blendShapes?[.browDownLeft]?.floatValue
    let browRight = blendShapes?[.browDownRight]?.floatValue

    let jawOpen = blendShapes?[.jawOpen]?.floatValue
    
    robot.robotEyeLid1?.orientation = simd_mul(
      simd_quatf(
        angle: deg2Rad(-120 + (90 * eyeBlinkLeft!)),
        axis: [1, 0, 0]),
      simd_quatf(
        angle: deg2Rad((90 * browLeft!) - (30 * browInnerUp!)),
        axis: [0, 0, 1])
    )

    robot.robotEyeLid2?.orientation = simd_mul(
      simd_quatf(
        angle: deg2Rad(-120 + (90 * eyeBlinkRight!)),
        axis: [1, 0, 0]),
      simd_quatf(
        angle: deg2Rad((-90 * browRight!) - (-30 * browInnerUp!)),
        axis: [0, 0, 1])
    )
    
    robot.robotJaw?.orientation = simd_quatf(
      angle: deg2Rad(-100 + (60 * jawOpen!)),
      axis: [1, 0, 0]
    )

    // When this value is false, the lasers are currently active and you have to wait for the action sequence to complete before triggering the lasers again.
    
    // If the user’s jaw is about 90% open and the lasers aren’t currently active, you can trigger the lasers.
    if (isLasersDone && jawOpen! > 0.9) {
      isLasersDone = false
      
      robot.notifications.showLasers.post()
      robot.actions.lasersDone.onAction = { _ in
        self.isLasersDone = true
      }
    }
  }
}
