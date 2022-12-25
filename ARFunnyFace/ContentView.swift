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
var robot: Experience.Robot!

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
    propId = propId >= 3 ? 3 : propId + 1
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



#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
