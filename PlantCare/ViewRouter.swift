//
//  MakeView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI

struct ViewRouter: View {
    @Binding var viewSelected: ViewSelected
    @Binding var inEditMode: Bool
    @ObservedObject var userData: PlantCareViewModel
    @ObservedObject var editPlant: EditPlantViewModel
    
    var body: some View {
        if viewSelected == .home {
            HomeView(inEditMode: $inEditMode, userData: userData, editPlant: editPlant)
        }
        if viewSelected == .search {
            Text("search")
        }
        if viewSelected == .profile {
            ProfileView(userData: userData)
        }
    }
}
