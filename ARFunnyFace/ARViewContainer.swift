//
//  ARViewContainer.swift
//  ARFunnyFace
//
//  Created by Zaid Neurothrone on 2022-12-25.
//

import ARKit
import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
  @Binding var propId: Int
  
  func makeUIView(context: Context) -> ARView {
    arView = ARView(frame: .zero)
    // Here, you set the view’s session delegate to the context coordinator, which now starts updating the session when it detects any changes.
    arView.session.delegate = context.coordinator
    return arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {
    // Remove previous anchors from other scenes
    arView.scene.anchors.removeAll()
    
    let arConfig = ARFaceTrackingConfiguration()
    uiView.session.run(arConfig, options: [.resetTracking, .removeExistingAnchors])
    
    switch(propId) {
    case 0: // Eyes
      let arAnchor = try! Experience.loadEyes()
      uiView.scene.anchors.append(arAnchor)
      break
    case 1: // Glasses
      let arAnchor = try! Experience.loadGlasses()
      uiView.scene.anchors.append(arAnchor)
      break
    case 2: // Mustache
      let arAnchor = try! Experience.loadMustache()
      uiView.scene.anchors.append(arAnchor)
      break
    case 3: // Robot
      let arAnchor = try! Experience.loadRobot()
      uiView.scene.anchors.append(arAnchor)
      robot = arAnchor
    default: break
    }
  }
  
  func makeCoordinator() -> ARCoordinator {
    .init(self)
  }
}
