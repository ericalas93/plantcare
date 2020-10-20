//
//  AppDelegate+Injection.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-10-14.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { AuthenticationService() }.scope(application)
    }
}
