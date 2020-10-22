//
//  ProfileView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-10-20.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userData: PlantCareViewModel
    @State var sharingViewOpen = false

    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 44)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Hi, \(userData.userFirstName)!")
                            .font(Font.title.bold())
                        Spacer()
                    }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .shadow(color: Color.gray.opacity(0.1), radius: 15, x: 0, y: 20)

                    VStack(alignment: .leading) {
                        UserInfoBlock(title: "House name", content: userData.userHouseName, update: userData.updateHouseName)
                        UserInfoBlock(title: "First name", content: userData.userFirstName)
                        UserInfoBlock(title: "Last name", content: userData.userLastName)
                        UserInfoBlock(title: "Email", content: userData.userEmail)
                        UserShared(with: userData.sharedWith, sharingViewOpen: $sharingViewOpen)
                        ShareRequest(from: userData.shareRequests)
                    }
                        .padding()
                    // 20 for bottom floating menu, 44 for top notch, 20 for extra space
                    .padding(.bottom, 104)
                }
                    .fullScreenCover(isPresented: $sharingViewOpen, content: ShareHomeInviteView.init)

            }
                .background(Color("MainBackground"))
        }
            .ignoresSafeArea(.all)
    }
}

struct ShareRequest: View {
    var from: Array<String>
    var body: some View {
        Text("Share Requests")
            .font(Font.subheadline.bold())
            .padding(.bottom, 5)
            .padding(.top)
        if(from.count > 0) {
            Text("By agreeing to the person's request, their home will appear in your home selection menu.")
                .padding(.bottom)
                .font(.caption)
            ForEach(from, id: \.self) { person in
                HStack {
                    Text(person)
                        .fontWeight(.light)
                    Spacer()
                    Button(action: { }) {
                        Text("Accept")
                            .foregroundColor(Color("GreenDark"))
                    }
                }
                    .padding(.bottom)
            }
        } else {
            Text("Nothing to worry about here!")
                .padding(.bottom)
                .font(.caption)
        }
    }
}

struct UserShared: View {
    var with: Array<String>
    @Binding var sharingViewOpen: Bool

    var body: some View {
        Text("Shared with")
            .font(Font.subheadline.bold())
            .padding(.bottom, 5)
            .padding(.top)
        if(with.count > 0) {
            Text("These people can view your plants and update when your plants were last watered, misted, or fertilized. They cannot modify your plants in any other way. Additionally, they cannot add or delete plants in your home.")
                .padding(.bottom)
                .font(.caption)
            ForEach(with, id: \.self) { person in
                HStack {
                    Text(person)
                        .fontWeight(.light)
                    Spacer()
                    Button(action: { }) {
                        Text("Stop Sharing")
                            .foregroundColor(Color("GreenDark"))
                    }
                }
                    .padding(.bottom)
            }
        } else {
            Text("You're currently not sharing your home and plants with anyone. Sharing allows the person to view your plants and update when your plants were last watered, misted, or fertilized. They cannot modify your plants in any other way. Additionally, they cannot add or delete plants in your home. ")
                .padding(.bottom)
                .font(.caption)
        }
        Button(action: { sharingViewOpen.toggle() }) {
            Text("Share with someone")
                .foregroundColor(Color("GreenDark"))
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("GreenDark"), lineWidth: 1)
                )
        }
    }
}

struct UserInfoBlock: View {
    var title: String
    @State var content: String
    var update: ((String) -> Void)? = nil
    var bottomDivider: Bool = true
    var body: some View {

        Section {
            Text(title)
                .font(Font.subheadline.bold())
                .padding(.bottom, 5)
                .padding(.top)
            if (update != nil) {
                HStack {
                    TextField(title, text: $content, onCommit: {
                        hideKeyboard()
                        update!(content)
                    })
                        .font(Font.body.weight(.light))
                    Button(action: {
                        hideKeyboard()
                        update!(content)
                    }, label: {
                            Text("Save")
                                .foregroundColor(Color("GreenDark"))
                                .opacity(content.count == 0 ? 0.5 : 1)
                        })
                        .disabled(content.count == 0)
                }
            } else {
                Text(content)
                    .fontWeight(.light)
                    .padding(.bottom)
            }
            Divider()
        }

    }
}

struct mock_PreviewView: View {
    @ObservedObject var userData = mockPlantViewModel

    init() {
        userData.userData = mockUserData
    }

    var body: some View {
        ProfileView(userData: userData)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        mock_PreviewView()
    }
}
