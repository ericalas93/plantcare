//
//  PlantDetailBackButton.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-24.
//

import SwiftUI

struct PlantDetailBackButton: View {
    @Environment(\.presentationMode) var showingDetails

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showingDetails.wrappedValue.dismiss()
                    
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 25))
                        .frame(width: 75, height: 75, alignment: .center)
                }
                .foregroundColor(.black)
                .offset(x: -30, y: -20)
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

struct PlantDetailBackButton_Previews: PreviewProvider {
    static var previews: some View {
        PlantDetailBackButton()
    }
}
