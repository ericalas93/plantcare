//
//  ContentView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI

enum ViewSelected: String {
    case home
    case search
    case profile
}

struct ContentView: View {
    @State var viewSelected : ViewSelected = .home;
    // hide floating tab bar
    @State var inEditMode = false
    @ObservedObject var userData: PlantCareViewModel
    @ObservedObject var editPlant = EditPlantViewModel(nil)
    
    init(_ userData: PlantCareViewModel?) {
        self.userData = userData ?? PlantCareViewModel()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { _ in
                ViewRouter(viewSelected: $viewSelected, inEditMode: $inEditMode, userData: userData, editPlant: editPlant)
            }
            FloatingTabbar(viewSelected: $viewSelected, inEditMode: $inEditMode)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("MainBackground").edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_mocked: View {
    @State var plantCareViewModel = mockPlantViewModel
    init() {
        plantCareViewModel.userData = mockUserData
    }
    
    var body: some View {
        ContentView(plantCareViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_mocked()
    }
}
