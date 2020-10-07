//
//  HouseViewModel.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-28.
//

import Foundation
import Combine
import FirebaseStorage

class PlantCareViewModel: ObservableObject {
    private var plantService = PlantService()
    private var STORAGE_URL = "gs://storagetrial-467d3.appspot.com";
    @Published var userData: UserData = UserData(userId: "", houses: [House](), currentHomeId: nil)
    @Published var busy = (isBusy: false, text: "")
  
    var cancellationToken: AnyCancellable?
    
    init() {
        getUserData()
    }

    // MARK: setters
    func setCurrentHome(ownerId: String) {
        let newCurrentHome = userData.houses.first { house in
            return house.ownerId == ownerId
        }
        userData.currentHomeId = newCurrentHome!.id
    }
    
    func insertPlant(_ plant: Plant, _ isNewPlant: Bool) {
        let currentHouseIdx = getCurrentHouseIdx()
        if (isNewPlant) {
            userData.houses[currentHouseIdx].plants.append(plant);
            self.busy = (isBusy: false, text: "")
            return;
        }
        
        let (_, plantIdx) = getPlantToUpdate(plantId: plant.id)
        userData.houses[currentHouseIdx].plants[plantIdx] = plant
        self.busy = (isBusy: false, text: "")
    }
    
    func savePlant(_ plant: Plant, _ isNewPlant: Bool, _ image: UIImage?) {
        if (image != nil) {
            // update image
            uploadImage(image!, plant, isNewPlant)
        } else {
            // user didnt change picture
            self.insertPlant(plant, isNewPlant)
        }
    }
    
    func uploadImage(_ image: UIImage, _ plant: Plant, _ isNewPlant: Bool) {
        // TODO: if image is new but on existing plant, add placeholder image (or from library eventually)
        self.busy = (isBusy: true, text: "Saving Plant")
        if let imageData = image.jpegData(compressionQuality: 1) {
            let storage = Storage.storage()
            let imageName = UUID().uuidString + ".jpg"
            let imageRef = storage.reference().child(imageName);
            
            imageRef.putData(imageData, metadata: nil) { (data, err) in
                if let err = err {
                    print("an error has occured - \(err.localizedDescription)")
                    // TODO error handling
                    return
                }
                
                imageRef.downloadURL { (url, error) in
                    guard let imageUrl = url else {
                        // TODO error handling
                        return
                    }
                    let plantWithUrl = Plant(id: plant.id, name: plant.name, lastWatered: plant.lastWatered, waterFrequency: plant.waterFrequency, lastMisted: plant.lastMisted, mistFrequency: plant.mistFrequency, lastFertilized: plant.lastFertilized, fertilizeFrequency: plant.fertilizeFrequency, imageUrl: imageUrl.absoluteString, family: plant.family, waterAmount: plant.waterAmount, sunAmount: plant.sunAmount, temperature: plant.temperature, fertilizerAmount: plant.fertilizerAmount, notes: plant.notes)
                    self.insertPlant(plantWithUrl, isNewPlant)
                }
            }
        } else {
            print("couldnt compress")
        }
    }
    
    // MARK: getters
    func getCurrentHouseIdx() -> Int {
        let houseIdx = userData.houses.firstIndex { house in
            return house.id == userData.currentHomeId
        }
        
        return houseIdx!
    }

    func getPlantToUpdate(plantId: Int) -> (houseIdx: Int, plantIdx: Int) {
        let houseIdx = getCurrentHouseIdx()

        let plantIdx = userData.houses[houseIdx].plants.firstIndex { plant in
            return plant.id == plantId
        }
        
        return (houseIdx: houseIdx, plantIdx: plantIdx!)

    }
    
    // MARK: updaters
    func waterPlant(plantId: Int) {
        let (houseIdx, plantIdx) = getPlantToUpdate(plantId: plantId)

        userData.houses[houseIdx].plants[plantIdx].lastWatered = Date()
    }

    // MARK: selectors
    var currentHousePlants: [Plant] {
        if (currentHouse == nil) {
            return [];
        }

        return currentHouse!.plants
    }
    
    var houses: [House] {
        return userData.houses
    }
    
    var currentHouse: House? {
        if (userData.currentHomeId == nil) {
            return nil
        }
        return userData.houses.first { house in
            return house.id == userData.currentHomeId
        }
    }
}

extension PlantCareViewModel {
    func getUserData() {
        cancellationToken = plantService.mock_fetchUserData()
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { data in
                    let currentHome = data.houses.first { house in
                        return house.ownerId == data.userId
                    }

                    self.userData = UserData(userId: data.userId, houses: data.houses, currentHomeId: currentHome!.id)
                }
            )
    }
}
