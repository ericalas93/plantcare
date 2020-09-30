//
//  HomeView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI

struct HomeView: View {
    @State var plantIdx: Int? = nil
    @State var showDetails = false
    @ObservedObject var userData = PlantCareViewModel()
    
    var body: some View {
        let localPlantIdx: Int? = self.plantIdx

        ScrollView(.vertical) {
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
                
                SummaryView(currentHousePlants: userData.currentHousePlants)
                    .padding(.bottom)
                
                VStack {
                    HStack(alignment: .top) {
                        Text("Plants")
                            .font(.title2)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.leading, 30)
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
                }
                .sheet(isPresented: $showDetails, onDismiss: {
                    self.plantIdx = nil
                }) {
                    NavigationView{
                        PlantDetailView(viewModel: userData, close: {
                            self.showDetails.toggle()
                        }, plant: userData.currentHousePlants[localPlantIdx!])
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                    }
                }
                Spacer()
            }
            .background(Color("MainBackground").ignoresSafeArea(.all))
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
