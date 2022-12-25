//
//  ContentView.swift
//  ARFunnyFace
//
//  Created by Zaid Neurothrone on 2022-12-25.
//

import ARKit
import RealityKit
import SwiftUI

var arView: ARView!

struct ContentView : View {
  @State var propId: Int = .zero
  
  var body: some View {
    ZStack(alignment: .bottom) {
      ARViewContainer(propId: $propId)
        .edgesIgnoringSafeArea(.all)
      
      HStack {
        Spacer()
        Button(action: decrementPropId) {
          Image("PreviousButton")
            .clipShape(Circle())
        }
        Spacer()
        Button(action: takeSnapshot) {
          Image("ShutterButton")
            .clipShape(Circle())
        }
        Spacer()
        Button(action: incrementPropId) {
          Image("NextButton")
            .clipShape(Circle())
        }
        Spacer()
      }
    }
  }
  
  func decrementPropId() {
    propId = propId <= .zero ? .zero : propId - 1
  }
  
  func incrementPropId() {
    propId = propId >= 2 ? 2 : propId + 1
  }
  
  func takeSnapshot() {
    arView.snapshot(saveToHDR: false) { image in
      let compressedImage = UIImage(
        data: (image?.pngData())!
      )
      UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
    }
  }
  
}

struct ARViewContainer: UIViewRepresentable {
  @Binding var propId: Int
  
  func makeUIView(context: Context) -> ARView {
    arView = ARView(frame: .zero)
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
    default: break
    }
  }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
