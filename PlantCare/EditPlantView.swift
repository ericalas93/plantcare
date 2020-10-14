//
//  EditPlantView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-09-29.
//

import SwiftUI
import URLImage

struct EditPlantView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var plant: EditPlantViewModel
    @ObservedObject var viewModel: PlantCareViewModel
    @Binding var inEditMode: Bool

    @State private var showingImageSourcePicker = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var source: UIImagePickerController.SourceType = .photoLibrary

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }

    var body: some View {
        NavigationView {
            Form {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)

                    if image == nil {
                        VStack {
                            if plant.imageUrl != "" {
                                URLImage(
                                    URL(string: plant.imageUrl)!,
                                    placeholder: Image("PlantStock"),
                                    content: { imageWrapper in
                                        imageWrapper.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                )
                            }
                            Text("Tap to select a picture")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                    else {
                        image?
                            .resizable()
                            .scaledToFit()
                    }
                }
                    .onTapGesture(count: 1, perform: {
                        self.showingImageSourcePicker = true
                    })

                Section(header: Text("Plant Info")) {
                    TextField("Plant name", text: $plant.name)
                    TextField("Plant family", text: $plant.family)
                }
                Section(header: Text("Sun Amount")) {
                    TextField("Sun Amount", text: $plant.sunAmount)
                }
                Section(header: Text("Temperature")) {
                    TextField("Temperature", text: $plant.temperature)
                    Picker("", selection: $plant.temperatureUnitSelection) {
                        ForEach(0..<plant.degrees.count) { index in
                            Text(self.plant.degrees[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Fertilizer Amount")) {
                    TextField("Fertilizer Amount", text: $plant.fertilizerAmount)
                }

                Section(header: Text("Water Information")) {
                    DatePicker(selection: $plant.lastWatered, in: ...Date(), displayedComponents: .date) {
                        Text("Last Watered")
                    }
                    Picker(selection: self.$plant.waterFrequency, label: Text("Frequency (Days)")) {
                        ForEach(0 ..< self.plant.frequencies.count) {
                            let dayText = self.plant.frequencies[$0] == 1 ? "Day" : "Days"
                            Text("Every \(self.plant.frequencies[$0]) \(dayText)")
                        }
                    }
                    TextField("Water Amount", text: $plant.waterAmount)
                }
                Section(header: Text("Mist Information")) {
                    DatePicker(selection: $plant.lastMisted, in: ...Date(), displayedComponents: .date) {
                        Text("Last Misted")
                    }
                    Picker(selection: self.$plant.mistFrequency, label: Text("Frequency (Days)")) {
                        ForEach(0 ..< self.plant.frequencies.count) {
                            let dayText = self.plant.frequencies[$0] == 1 ? "Day" : "Days"
                            Text("Every \(self.plant.frequencies[$0]) \(dayText)")
                        }
                    }
                }
                Section(header: Text("Fertilizer Information")) {
                    DatePicker(selection: $plant.lastFertilized, in: ...Date(), displayedComponents: .date) {
                        Text("Last Misted")
                    }
                    Picker(selection: self.$plant.fertilizeFrequency, label: Text("Frequency (Days)")) {
                        ForEach(0 ..< self.plant.frequencies.count) {
                            let dayText = self.plant.frequencies[$0] == 1 ? "Day" : "Days"
                            Text("Every \(self.plant.frequencies[$0]) \(dayText)")
                        }
                    }
                }

                Section(header: Text("More Information")) {
                    TextEditor(text: $plant.notes)
                }
            }
                .alert(isPresented: self.$plant.attempted) {
                    Alert(title: Text("Unsaved Changes"),
                        message: Text("You have made changes to the form that have not been saved. If you continue, those changes will be lost."),
                        primaryButton: .destructive(Text("Delete Changes"), action: {
                                self.plant.discardChanges()
                                self.presentationMode.wrappedValue.dismiss()
                            }),
                        secondaryButton: .cancel(Text("Continue Editing")))
                }

                .navigationBarTitle(plant.isNewPlant ? "Add New Plant" : "Edit Plant", displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button(action: {
                            if (self.plant.preventDismissal) {
                                self.plant.updateAttempted()
                            } else {
                                self.plant.discardChanges()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                    },
                    trailing:
                        Button("Save") {
                            let (plant, isNewPlant) = self.plant.save(existingPlants: viewModel.currentHousePlants)
                            viewModel.savePlant(plant, isNewPlant, self.inputImage)
                            self.plant.resetForm()
                            self.presentationMode.wrappedValue.dismiss()

                        }.disabled(plant.preventSave)
                )
                .actionSheet(isPresented: $showingImageSourcePicker, content: {
                    ActionSheet(title: Text("Select Source"), buttons: [
                                .default(Text("Photo Library")) {
                                    self.source = .photoLibrary
                                    self.showingImagePicker = true

                            },
                                .default(Text("Camera")) {
                                    self.source = .camera
                                    self.showingImagePicker = true

                            },
                                .cancel()
                        ])
                })
                .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage, source: self.source)
            }

        }
            .onAppear {
                self.inEditMode = true
            }.onDisappear {
                self.inEditMode = false
        }
    }
}

struct mock_WrappedView: View {
    @State var show = true
    @State var inEditMode = false

    var body: some View {
        let plant = mockPlantNoNotes
        VStack {
            Text("asdf")
        }.sheet(isPresented: $show, content: {
            NavigationView {
                EditPlantView(plant: EditPlantViewModel(plant), viewModel: PlantCareViewModel(), inEditMode: $inEditMode)
                    .navigationTitle("")
                    .navigationBarHidden(true)
            }
        })
    }
}
struct EditPlantView_Previews: PreviewProvider {
    static var previews: some View {
        mock_WrappedView()
    }
}
