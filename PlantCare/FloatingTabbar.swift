//
//  FloatingTabbar.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI

struct FloatingTabbar: View {
    @Binding var viewSelected : ViewSelected
    @State var navExpanded = false

    var body: some View {
        HStack {
            Spacer()
            HStack {
                if !navExpanded {
                    HStack {
                        Button(action: {
                            self.navExpanded.toggle()
                        }){
                            Image(systemName: "arrow.left").foregroundColor(.white).padding();
                        }
                    }
                } else {
                    Button(action: {
                        self.viewSelected = .home
                    }) {
                        Image(systemName: self.viewSelected == .home ? "house.fill" : "house")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .thin))
                    }
                    Spacer(minLength: 15)
                    Button(action: {
                        self.viewSelected = .search
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: self.viewSelected == .search ? .bold : .thin))
                    }
                    Spacer(minLength: 15)
                    Button(action: {
                        self.viewSelected = .profile
                    }) {
                        Image(systemName: self.viewSelected == .profile ? "person.fill" : "person")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .thin))
                    }
                    Spacer(minLength: 15)
                    Button(action: {
                        self.navExpanded.toggle()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                        
                            .font(.system(size: 24, weight: .thin))
                    }
                }
            }
            .padding(.vertical, self.navExpanded ? 20 : 8)
            .padding(.horizontal, self.navExpanded ? 20 : 8)
            .background(Color("GreenDark"))
            .clipShape(Capsule())
            .padding(20)
            .shadow(radius: 4)
            .onLongPressGesture {
                self.navExpanded.toggle()
            }
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.6))
        }
    }
}

struct FloatingTabbar_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
