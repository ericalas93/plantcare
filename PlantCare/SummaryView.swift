//
//  SummaryView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-15.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Summary")
                    .font(.title2)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.leading, 30)
            
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Color("GreenDark").frame(width: 2, height: 36)
                            .padding(.trailing, 6)
                        VStack(alignment: .leading) {
                            Text("Total Plants")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("42")
                                .font(.headline)
                        }
                    }
                    .padding(.top)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Color.yellow.frame(width: 2, height: 36)
                            .padding(.trailing, 6)
                        VStack(alignment: .leading) {
                            Text("Overdue")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("3")
                                .font(.headline)
                        }
                    }
                    .padding(.top)
                    .padding(.leading)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .padding(.leading)
                        .padding(.trailing)
                    Text("More info...")
                        .padding(.top)
                        .padding(.bottom)
                        .padding(.leading)
                        .font(.subheadline)
                }
                .background(Color.white)
                .cornerRadius(radius: 10, corners: [.topLeft, .bottomLeft, .bottomRight])
                .cornerRadius(radius: 80, corners: [.topRight])
                .padding(.leading, 30)
                .padding(.trailing, 30)
                .shadow(color: Color.gray.opacity(0.25), radius: 5, x: 2, y: 2)
            }
            
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
