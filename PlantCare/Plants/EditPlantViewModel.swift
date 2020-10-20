//
//  EditPlantViewModel.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-29.
//

import Foundation

class EditPlantViewModel: ObservableObject {
    @Published var preventDismissal: Bool = false
    @Published var attempted: Bool = false
    @Published var isNewPlant = false
    @Published var preventSave = true
    
    private var defaultPlantImage = "https://watchandlearn.scholastic.com/content/dam/classroom-magazines/watchandlearn/videos/animals-and-plants/plants/what-are-plants-/english/wall-2018-whatareplantsmp4.transform/content-tile-large/image.png"

    var frequencies = Array(1...60)
    var degrees = ["Celsius", "Fahrenheit"]
    
    var originalPlant: Plant?
    var id: String?
    
    @Published var temperatureUnitSelection: Int = 1 {
        didSet { updateDismissability() }
    }
    
    @Published var name: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var lastWatered: Date = Date() {
        didSet { updateDismissability() }
    }
    
    @Published var waterFrequency: Int = 0 {
        didSet { updateDismissability() }
    }
    
    @Published var lastMisted: Date = Date() {
        didSet { updateDismissability() }
    }
    
    @Published var mistFrequency: Int = 0 {
        didSet { updateDismissability() }
    }
    
    @Published var lastFertilized: Date = Date() {
        didSet { updateDismissability() }
    }
    
    @Published var fertilizeFrequency: Int = 0 {
        didSet { updateDismissability() }
    }
    
    @Published var imageUrl: String = "" {
        didSet { updateDismissability() }
    }

    @Published var family: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var waterAmount: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var sunAmount: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var temperature: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var fertilizerAmount: String = "" {
        didSet { updateDismissability() }
    }
    
    @Published var notes: String = "" {
        didSet { updateDismissability() }
    }

    func updateDismissability() {
        self.preventDismissal = true
        self.preventSave = self.name == "" || self.family == "" || self.sunAmount == "" || self.temperature == "" || self.fertilizerAmount == "" || self.waterAmount == ""
    }

    func save(existingPlants: [Plant], userId: String) -> (plant: Plant, isNewPlant: Bool) {
        let url = isNewPlant ? defaultPlantImage : self.imageUrl
        let id = self.isNewPlant ? UUID().uuidString : self.id!;
        let tempUnit = self.temperatureUnitSelection == 0 ? "C" : "F"
        let tempComplete = self.temperature + "°" + tempUnit
        let plant = Plant(id: id, name: self.name, lastWatered: self.lastWatered, waterFrequency: self.waterFrequency + 1, lastMisted: self.lastMisted, mistFrequency: self.mistFrequency + 1, lastFertilized: self.lastFertilized, fertilizeFrequency: self.fertilizeFrequency + 1, imageUrl: url, family: self.family, waterAmount: self.waterAmount, sunAmount: self.sunAmount, temperature: tempComplete, fertilizerAmount: self.fertilizerAmount, notes: self.notes, ownerId: userId)
        return (plant, isNewPlant)
    }
    
    func resetForm() {
        self.id = nil
        self.name = ""
        self.lastWatered = Date()
        self.waterFrequency = 0
        self.lastMisted = Date()
        self.mistFrequency = 0
        self.lastFertilized = Date()
        self.fertilizeFrequency = 0
        self.imageUrl = ""
        self.family = ""
        self.sunAmount = ""
        self.waterAmount = ""
        self.temperature = ""
        self.fertilizerAmount = ""
        self.notes = ""
        self.isNewPlant = true
        self.attempted = false
        self.preventDismissal = false
    }
    
    func resetDismissal() {
        self.preventDismissal = false
        self.attempted = false
    }

    init(_ plant: Plant?) {
        if (plant != nil) {
            self.setPlant(plant!)
        } else {
            self.isNewPlant = true
        }
    }
    
    func discardChanges() {
        if (self.isNewPlant) {
            self.resetForm()
        } else {
            self.setPlant(self.originalPlant!)            
        }
    }
    
    func setPlant(_ plant: Plant) {
        self.isNewPlant = false
        self.originalPlant = plant
        self.id = originalPlant!.id
        self.name = originalPlant!.name
        self.lastWatered = originalPlant!.lastWatered
        self.waterFrequency = originalPlant!.waterFrequency
        self.lastMisted = originalPlant!.lastMisted
        self.mistFrequency = originalPlant!.mistFrequency
        self.lastFertilized = originalPlant!.lastFertilized
        self.fertilizeFrequency = originalPlant!.fertilizeFrequency
        self.imageUrl = originalPlant!.imageUrl
        self.family = originalPlant!.family
        self.waterAmount = originalPlant!.waterAmount
        self.sunAmount = originalPlant!.sunAmount
        self.temperature = originalPlant!.temperature
        self.fertilizerAmount = originalPlant!.fertilizerAmount
        self.notes = originalPlant!.notes
        self.preventDismissal = false
    }
    
    func updateAttempted() {
        self.attempted.toggle()
    }
}
