//
//  HomeView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI

struct HomeView: View {
    @Binding var inEditMode: Bool

    @State var plantIdx: Int? = nil
    @State var showDetails = false
    @State var plantChanges = false
    @State var isNavigationBarHidden = true
    @State var addNewPlant = false
    @State var viewAllPlants = false

    @ObservedObject var userData: PlantCareViewModel
    @ObservedObject var editPlant: EditPlantViewModel

    var body: some View {
        let localPlantIdx: Int? = self.plantIdx

        NavigationView {
            VStack {
                if userData.busy.isBusy {
                    ProgressView(userData.busy.text)
                }
                NavigationLink(destination: EditPlantView(plant: editPlant, viewModel: userData, inEditMode: $inEditMode)
                        .navigationTitle("")
                        .navigationBarHidden(true), isActive: self.$addNewPlant) {
                    EmptyView()
                }
                NavigationLink(destination: Text("View all plants here")
                        .navigationTitle("All Plants"), isActive: self.$viewAllPlants) {
                    EmptyView()
                }
                VStack {
                    HStack {
                        Text(userData.currentHouse?.name ?? "My Home")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        HStack(alignment: .top) {
                            Menu {
                                Text("Switch House: ")
                                    .foregroundColor(.red)
                                Divider()
                                    .frame(minHeight: 20)
                                ForEach(userData.houses) { house in
                                    HStack {
                                        Button(action: {
                                            userData.setCurrentHome(ownerId: house.ownerId)
                                        }, label: {
                                                if house.ownerId == userData.currentHouse?.ownerId {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(.black)
                                                }
                                                Text(house.name)
                                            })
                                    }
                                }

                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                        .padding([.top, .leading, .trailing], 30)


                    ScrollView(.vertical) {
                        SummaryView(currentHousePlants: userData.currentHousePlants)
                            .padding(.bottom)

                        VStack {
                            HStack(alignment: .top) {
                                Text("Plants")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                Spacer()
                                Menu {
                                    if (self.userData.ownsCurrentHouse) {
                                        Button("Add New Plant") {
                                            self.addNewPlant = true
                                        }
                                    }
                                    Button("View all Plants") {
                                        self.viewAllPlants = true
                                    }
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                }
                                    .padding(.trailing, 30)
                            }
                                .padding(.leading, 30)
                            ZStack(alignment: .bottomTrailing) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(userData.currentHousePlants.indices, id: \.self) { plantIdx in
                                            let plant = userData.currentHousePlants[plantIdx]
                                            GeometryReader { geometry in
                                                PlantListItemView(plant: plant)
                                                    .padding(.leading)
                                                    .padding(.bottom)
                                                    .onTapGesture {
                                                        self.plantIdx = plantIdx;
                                                        self.editPlant.setPlant(userData.currentHousePlants[plantIdx])
                                                        self.showDetails.toggle()
                                                }
                                                // 1140 because when its at 220 (width size) we want 80%,
                                                // result = 220 of 1140 is 20%, so 220 is 1/5 of 1140
                                                // hence the 1 - result
                                                // abs, so that when its less than 0, we start to zoom out again
                                                .scaleEffect(1 - abs(geometry.frame(in: .global).minX / 1140), anchor: .center)
                                            }
                                                .frame(width: 220, height: 140)
                                        }
                                    }
                                }
                                if (self.userData.ownsCurrentHouse) {
                                    NavigationLink(destination: EditPlantView(plant: editPlant, viewModel: userData, inEditMode: $inEditMode)
                                            .navigationTitle("")
                                            .navigationBarHidden(true)) {
                                        Image(systemName: "plus").foregroundColor(.white)
                                            .padding()
                                            .background(Color("GreenDark"))
                                            .clipShape(Circle())
                                            .padding()
                                    }
                                }

                            }
                        }
                        Spacer()
                    }
                        .sheet(isPresented: $showDetails, onDismiss: {
                            self.editPlant.resetForm()
                            self.plantIdx = nil
                        }) {
                            NavigationView {
                                PlantDetailView(viewModel: userData, editPlantModel: self.editPlant, close: {
                                    self.plantIdx = nil
                                    self.showDetails.toggle()
                                }, plant: userData.currentHousePlants[localPlantIdx!])
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                            }.presentation(isModal: $editPlant.preventDismissal) {
                                self.editPlant.attempted = true
                            }
                    }
                }
            }
                .navigationBarTitle("")
                .navigationBarItems(
                    trailing:
                        Button("Save") {

                    })
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
            }
        }
            .background(Color("MainBackground").ignoresSafeArea(.all))
    }

}

struct mock_HomeView: View {
    @State var inEditMode = false
    @ObservedObject var userData = mockPlantViewModel
    @ObservedObject var editPlant = EditPlantViewModel(nil)

    init() {
        userData.userData = mockUserData
    }

    var body: some View {
        HomeView(inEditMode: $inEditMode, userData: userData, editPlant: editPlant)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        mock_HomeView()
    }
}
