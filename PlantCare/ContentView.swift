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

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { _ in
                ViewRouter(viewSelected: $viewSelected)
            }
            FloatingTabbar(viewSelected: $viewSelected)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("MainBackground").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
