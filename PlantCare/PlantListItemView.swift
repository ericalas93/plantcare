//
//  PlantListItemView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-22.
//

import SwiftUI
import URLImage

struct PlantListItemView: View {
    var plant: Plant

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                    .frame(width: 60)
                    .frame(minWidth: 60)
                VStack(alignment: .leading) {
                    Text(plant.name)
                        .frame(width: 110, height: 60, alignment: .leading)
                        .lineLimit(2)
                        .font(Font.title3.bold())
                        .foregroundColor(Color("GreenDark"))
                        .shadow(color: .black, radius: 0.01)
                    Text("Watered on:")
                        .frame(width: 110, alignment: .leading)
                        .font(.caption2)
                        .lineLimit(2)
                        .foregroundColor(.white)
                    Text(getDateString(date: plant.lastWatered))
                        .frame(width: 110, alignment: .leading)
                        .font(Font.caption.bold())
                        .lineLimit(2)
                        .foregroundColor(.white)
                }
            }
                .frame(width: 180, height: 120)
                .background(Color("GreenSecondaryLight"))
                .cornerRadius(10)
                .offset(x: 40, y: 0)
                .padding(.trailing, 40)
                .shadow(color: Color.gray.opacity(0.25), radius: 5, x: 2, y: 0)


            URLImage(
                URL(string: plant.imageUrl)!,
                placeholder: Image("PlantStock"),
                content: {
                    $0.image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .frame(minWidth: 100, minHeight: 100)
                        .background(Color("GreyLight"))
                        .cornerRadius(10)
                        .offset(x: -60, y: 0)
                        .shadow(color: Color.gray.opacity(0.25), radius: 5, x: 2, y: 2)
                }
            )

        }
    }
}

struct PlantListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlantListItemView(plant: mockPlantNoNotes)
    }
}
