//
//  PlantCareApp.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI
import Firebase
import Resolver

@main
struct PlantCareApp: App {
    @Injected var authenticationService: AuthenticationService

    init() {
        if (!isPreview()) {
            FirebaseApp.configure()
            authenticationService.signIn()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(nil)
        }
    }
}

func isPreview() -> Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1";
}
