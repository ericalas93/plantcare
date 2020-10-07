//
//  PlantCareApp.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI
import Firebase

@main
struct PlantCareApp: App {
    init() {
        #if targetEnvironment(simulator)
        #else
            FirebaseApp.configure()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
