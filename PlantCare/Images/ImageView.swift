//
//  ImageView.swift
//  PlantCare
//
//  Created by Alas, Eric on 2020-10-02.
//

import SwiftUI
import URLImage

struct ImageView: View {
    var imageUrl : String?
    var inputImage: UIImage?
    var image: Image?
    var content: (_ imageWrapper: Any) -> ContentView? = { _ in  }
    
    mutating func loadImage() {
        guard let inputImage = inputImage else { return }
        self.image = Image(uiImage: inputImage)
    }

    var body: some View {
        if imageUrl != nil {
            URLImage(
                URL(string: imageUrl!)!,
                placeholder: Image("PlantStock"),
//                content: { imageWrapper in
//                    GeometryReader { geo in
//                        imageWrapper.image
//                            .resizable()
//                            .frame(width: geo.size.width, height: 400)
//                            .onTapGesture(count: 1) {
//                                self.fullImage.toggle()
//                        }
//                    }
//                }
                content: { imageWrapper in
                    content(imageWrapper)
                }
            )
        } else {
            image
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageUrl: "https://watchandlearn.scholastic.com/content/dam/classroom-magazines/watchandlearn/videos/animals-and-plants/plants/what-are-plants-/english/wall-2018-whatareplantsmp4.transform/content-tile-large/image.png")
    }
}
