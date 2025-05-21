//  ContentView.swift
//  shapeMaker
//
//  Created by Jack Brodie on 12/05/2025.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    let handTracker = HandTracker()
    
    var body: some View {
        VStack {
            ToggleImmersiveSpaceButton()
        }
        .task {
            await handTracker.startTracking()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
