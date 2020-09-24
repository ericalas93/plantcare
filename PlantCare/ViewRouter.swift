//
//  MakeView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI

struct ViewRouter: View {
    @Binding var viewSelected: ViewSelected
    var body: some View {
        if viewSelected == .home {
            HomeView()
        }
        if viewSelected == .search {
            Text("search")
        }
        if viewSelected == .profile {
            Text("profile")
        }
    }
}
