//
//  ShareHomeInviteView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-10-21.
//

import SwiftUI

struct ShareHomeInviteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var shareEmail: String = ""

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.black)
                    })
                    .offset(x: -15)
                    .padding()
                    Spacer()
                }
                .padding([.leading, .trailing, .top])
                VStack(alignment: .leading) {
                    Text("Sharing")
                        .font(.title).fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("Share your home and your plants.")
                        .font(.title2)
                        .padding(.bottom, 5)
                    Text("These people can view your plants and update when your plants were last watered, misted, or fertilized. They cannot modify your plants in any other way. Additionally, they cannot add or delete plants in your home.")
                        .font(.body)
                        .fontWeight(.light)
                        .padding(.bottom)
                    TextField("Please enter an e-mail", text: self.$shareEmail)
                        .keyboardType(.emailAddress)
                        .padding(.bottom, 5)
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color("Border")), alignment: .bottom)
                    
                }
                .padding([.leading, .trailing])
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Share")
                            .foregroundColor(.white)
                    })
                    .disabled(shareEmail.count == 0)
                    .padding([.top, .bottom], 15)
                    .padding([.leading, .trailing], 30)
                    .background(Color("GreenDark"))
                    .cornerRadius(5)
                    .opacity(shareEmail.count == 0 ? 0.50 : 1)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color("Border")), alignment: .top)
                .background(Color("SecondaryBackground"))
            }
            .padding(.top)
            .ignoresSafeArea(.container)
        }
            .frame(maxWidth: .infinity)

    }
}

struct ShareHomeInviteView_Previews: PreviewProvider {
    static var previews: some View {
        ShareHomeInviteView()
    }
}
