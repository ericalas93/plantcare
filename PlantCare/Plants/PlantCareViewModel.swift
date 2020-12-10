//
//  HouseViewModel.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-28.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import Resolver

class PlantCareViewModel: ObservableObject {
    @Injected var authenticationService: AuthenticationService
    @Injected var localNotificationManager: LocalNotificationManager

    private var STORAGE_URL = "gs://storagetrial-467d3.appspot.com";
    @Published var userData: UserData = UserData(houses: [House](), currentHomeId: nil)
    @Published var busy = (isBusy: false, text: "")
    var userId: String = "unknown" {
        didSet {
            self.loadData()
        }
    }

    var db: Firestore?
    private var cancellables = Set<AnyCancellable>()
    var cancellationToken: AnyCancellable?

    var decoder: JSONDecoder {
        let _decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        _decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return _decoder
    }

    init() {
        if(!isPreview()) {
            db = Firestore.firestore()
            authenticationService.$user
                .compactMap { user in
                    user?.uid
                }
                .assign(to: \.userId, on: self)
                .store(in: &cancellables)
        }
    }

    // MARK: setters
    func setCurrentHome(ownerId: String) {
        let newCurrentHome = userData.houses.first { house in
            return house.ownerId == ownerId
        }
        userData.currentHomeId = newCurrentHome!.id
    }

    // MARK: getters
    func getMyHome() -> House? {
        return userData.houses.first { house in
            return house.ownerId == self.userId
        }
    }

    // MARK: selectors
    var currentHousePlants: [Plant] {
        if (currentHouse == nil) {
            return [];
        }

        return self.userData.plants.filter { plant in
            return plant.ownerId == self.userData.currentHomeId
        }
    }

    var ownsCurrentHouse: Bool {
        return self.userId == self.userData.currentHomeId
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

    var userFirstName: String {
        let ownerHouse = getMyHome()
        return ownerHouse?.firstName ?? "User"
    }

    var userLastName: String {
        let ownerHouse = getMyHome()

        return ownerHouse?.lastName ?? "User"
    }

    var userEmail: String {
        let ownerHouse = getMyHome()

        return ownerHouse?.ownerEmail ?? "example@example.com"
    }

    var userFullName: String {
        return "\(self.userFirstName)  \(self.userLastName)"
    }

    var sharedWith: Array<String> {
        let ownerHouse = getMyHome()


        if (ownerHouse!.sharedWith.count > 0) {
            return ownerHouse!.sharedWith.map { contact in
                return contact.email
            }
        }

        return []
    }

    var shareRequests: Array<String> {
        let ownerHouse = getMyHome()

        if (ownerHouse!.shareRequests.count > 0) {
            return ownerHouse!.shareRequests.map { contact in
                return contact.email
            }
        }

        return []
    }

    var userHouseName: String {
        let ownerHouse = getMyHome()

        return ownerHouse?.name ?? "My House"
    }

}

extension PlantCareViewModel {
    func loadData() {
        fetchUserData()
    }

    func fetchUserData() {
        db!.collection("houses").document(self.userId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }

                do {
                    let _data = try JSONSerialization.data(withJSONObject: data)
                    let house = try self.decoder.decode(House.self, from: _data)

                    self.userData = UserData(houses: [house], currentHomeId: house.id)
                    self.fetchPlants(for: self.userId)
                    self.fetchSharedHouses(to: ["ownerId": self.userId, "email": house.ownerEmail])
                } catch _ {
                    print("error fetching user data")
                }
        }
    }

    func fetchSharedHouses(to currentUser: [String: String?]) {
        db!.collection("houses").whereField("sharedWith", arrayContainsAny: [currentUser])
            .addSnapshotListener { querySnapshot, error in

                if let querySnapshot = querySnapshot {
                    let houses = querySnapshot.documents.compactMap { document -> House? in
                        do {
                            let _data = try JSONSerialization.data(withJSONObject: document.data())
                            let house = try self.decoder.decode(House.self, from: _data)

                            // fetch this persons plants
                            self.fetchPlants(for: house.ownerId)
                            return house
                        } catch _ {
                            print("error fetching shared houses")
                            return nil
                        }

                    }

                    self.userData.houses.append(contentsOf: houses)
                }
        }
    }

    func fetchPlants(for userId: String) {
        db!.collection("plants").whereField("ownerId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    print("fetching plants")
                    querySnapshot.documents.forEach { document in
                        do {
                            let _data = try JSONSerialization.data(withJSONObject: document.data())
                            let plant = try self.decoder.decode(Plant.self, from: _data)
                            let existingIdx = self.userData.plants.firstIndex { existingPlant in
                                return existingPlant.id == plant.id
                            }

                            self.plantNotification(plant: plant)
                            if (existingIdx != nil) {
                                self.userData.plants[existingIdx!] = plant
                            } else {
                                self.userData.plants.append(plant)
                            }
                        } catch _ {
                            print("error fetching plants")
                        }

                    }
                }
        }
    }

    func plantNotification(plant: Plant) {
        // TODO:  id is different based on type
        let waterPlantId = plant.id + "-water"
//        let mistPlantId = plant.id + "-mist"
//        let fertilizePlantId = plant.id + "-fertilize"
        self.localNotificationManager.getNotificationById(id: waterPlantId).subscribe(
            Subscribers.Sink(
                receiveCompletion: { _ in },
                receiveValue: { notification in
                    self.setNotification(notification: notification, lastDay: plant.lastWatered, frequency: plant.waterFrequency, type: .water, plant: plant)
                }
            )
        )
    }

    func setNotification(notification: UNNotificationRequest?, lastDay: Date, frequency: Int, type: PlantUpdateType, plant: Plant) {
        var title: String
        var id = plant.id

        switch type {
            case .water:
                title = "Your plant needs watering"
                id += "-water"
            case .mist:
                title = "Your plant needs misting"
                id += "-mist"
            case .fertilize:
                title = "Your plant needs fertilizing"
                id += "-fertilize"
        }

        if(notification == nil) {
            let dateComponents = self.getNextDate(increment: plant.waterFrequency)
            self.localNotificationManager.sendNotification(id: id, title: title, subtitle: nil, body: "\"\(plant.name)\" needs a little love!", dateComponents: dateComponents)
        } else {
            // update with frequency + last water date iff lastWaterDate + frequency !== notifiction date&time
            print("notification exists:" )
            print(notification.debugDescription)
        }
    }
}

// MARK: Updaters
extension PlantCareViewModel {
    func waterPlant(plantId: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let today = Date()
        let newLastWaterDate = formatter.string(from: today)
        
        db!.collection("plants").document(plantId).updateData(["lastWatered": newLastWaterDate]) { err in
            if let err = err {
                print("Error updating house name: \(err)")
            } else {
                let plant = self.userData.plants.first { _plant in
                    return _plant.id == plantId
                }!
                let notificationId = plantId + "-water"
//                let dateComponents = self.getNextDate(increment: plant.waterFrequency)
                let dateComponents = self.getNextDate(increment: 1)

                self.localNotificationManager.sendNotification(id: notificationId, title: "Your plant needs watering", subtitle: nil, body: "\"\(plant.name)\" needs a little love!", dateComponents: dateComponents)
                
            }
        }

    }
    
    func getNextDate(increment: Int) -> DateComponents {
        let today = Date()
        let calendar = Calendar.current
        // TODO: change to days
        let newNextDate = Calendar.current.date(byAdding: .minute, value: increment, to: today)!

        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newNextDate)
        return dateComponents
    }

    func insertPlant(_ plant: Plant, _ isNewPlant: Bool) {
        if (isNewPlant) {
            db!.collection("plants").document(plant.id).setData(plant.dictionary)
        } else {
            db!.collection("plants")
                .document(plant.id)
                .setData(plant.dictionary)
        }

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

    // MARK: updater helpers
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
                    let plantWithUrl = Plant(id: plant.id, name: plant.name, lastWatered: plant.lastWatered, waterFrequency: plant.waterFrequency, lastMisted: plant.lastMisted, mistFrequency: plant.mistFrequency, lastFertilized: plant.lastFertilized, fertilizeFrequency: plant.fertilizeFrequency, imageUrl: imageUrl.absoluteString, family: plant.family, waterAmount: plant.waterAmount, sunAmount: plant.sunAmount, temperature: plant.temperature, fertilizerAmount: plant.fertilizerAmount, notes: plant.notes, ownerId: self.userId)
                    self.insertPlant(plantWithUrl, isNewPlant)
                }
            }
        } else {
            print("couldnt compress")
        }
    }

    func updateHouseName(_ to: String) {
        let ownerHouse = getMyHome()

        if (ownerHouse!.name != to) {
            print("updating user's house name from \(ownerHouse!.name) to \(to)")
            db!.collection("houses").document(self.userId).updateData(["name": to]) { err in
                if let err = err {
                    print("Error updating house name: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
}

