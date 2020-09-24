//
//  HomeView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-14.
//

import SwiftUI

//struct Plant: Identifiable {
//    var id = UUID()
//    var name: String
//    var lastWatered = Calendar.current.date(byAdding: .day, value: -4, to: Date())
//    var nextWater =  Calendar.current.date(byAdding: .day, value: 1, to: Date())
//    var lastMisted = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//    var nextMist = Calendar.current.date(byAdding: .day, value: 2, to: Date())
//    var lastFertilized = Calendar.current.date(byAdding: .day, value: -5, to: Date())
//    var nextFertilize = Calendar.current.date(byAdding: .day, value: 15, to: Date())
//    var imageId = "monstera"
//    var family : String
//}

struct HomeView: View {
//    @State var plants: Array<Plant> = [
//        Plant(name: "Monstera deliciosa", family: "Plant Family1"),
//        Plant(name: "Another Plant", family: "Plant Family2"),
//        Plant(name: "Another Plant2", family: "Plant Family3"),
//        Plant(name: "One More Plant", family: "Plant Family4"),
//        Plant(name: "Last Plant", family: "Plant Family5")
//    ]
    @State var plantSelected: Plant? = nil
    @State var showDetails = false
    @ObservedObject var viewPlant = PlantViewModel()

    
    var body: some View {
        let localPlantSelected: Plant? = self.plantSelected

        VStack {
            HStack(alignment: .top) {
                Text("My Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
                .padding(.top)
                .padding(.leading)
                .padding(.bottom)

            SummaryView()
                .padding(.bottom)

            VStack {
                HStack(alignment: .top) {
                    Text("My Plants")
                        .font(.title2)
                        .foregroundColor(.black)
                    Spacer()
                }
                    .padding(.leading, 30)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewPlant.plants) { plant in
                            GeometryReader { geometry in
                                PlantListItemView(plant: plant)
                                    .padding(.leading)
                                    .padding(.bottom)
                                    .onTapGesture {
                                        self.plantSelected = plant;
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
                    self.plantSelected = nil
                }) {
                    PlantDetailView(plant: localPlantSelected!)
            }
            Spacer()
        }
        .background(Color("MainBackground").ignoresSafeArea(.all))
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
