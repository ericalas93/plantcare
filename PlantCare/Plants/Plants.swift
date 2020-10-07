//
//  Plants.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-23.
//

import Foundation
import SwiftUI

struct PlantData: Decodable {
    let owner: String
    let ownerId: String
    let plants: [Plant]

    enum CodingKeys: String, CodingKey {
        case plants = "results"
        case owner
        case ownerId
    }
}

struct Plant: Decodable, Identifiable {
    var id: Int
    var name: String
    var lastWatered: Date
    var waterFrequency: Int
    var lastMisted: Date
    var mistFrequency: Int
    var lastFertilized: Date
    var fertilizeFrequency: Int
    var imageUrl: String
    var family: String
    var waterAmount: String
    var sunAmount: String
    var temperature: String
    var fertilizerAmount: String
    var notes: String
}

//class Image {
//    var image: UIImage?
//    var urlString: String?
//
//    init(urlString: String?) {
//        self.urlString = urlString
//        loadImage()
//    }
//
//    func loadImage() {
//        loadImageFromUrl()
//    }
//
//    func loadImageFromUrl() {
//        guard let urlString = urlString else {
//            return
//        }
//
//        let url = URL(string: urlString)!
//        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data: response: error:))
//        task.resume()
//    }
//    
//    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
//           guard error == nil else {
//               print("Error: \(error!)")
//               return
//           }
//           guard let data = data else {
//               print("No data found")
//               return
//           }
//           
//           DispatchQueue.main.async {
//               guard let loadedImage = UIImage(data: data) else {
//                   return
//               }
//               
////               self.imageCache.set(forKey: self.urlString!, image: loadedImage)
//               self.image = loadedImage
//           }
//       }
//}
