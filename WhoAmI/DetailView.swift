//
//  ImageSaveView.swift
//  WhoAmI
//
//  Created by FABRICIO ALVARENGA on 02/10/22.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .padding(10)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
    }
}

struct DetailView: View {
    private var inputImage: UIImage?
    private var photoId: UUID
        
    @Binding private var photos: [Photo]
    @State private var image: Image
    @State private var canLoadPhoto: Bool
    @State private var photoName = ""
       
    @FocusState private var textFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(photos: Binding<[Photo]>, photoId: UUID, photoName: String, inputImage: UIImage?) {
        self.inputImage = inputImage
        self.photoId = photoId
        
        _photos = photos
        _photoName = State(initialValue: photoName)
        
        if let inputImage = inputImage {
            _image = State(initialValue: Image(uiImage: inputImage))
            _canLoadPhoto = State(initialValue: true)
        } else {
            _image = State(initialValue: Image(systemName: "exclamationmark.triangle"))
            _canLoadPhoto = State(initialValue: false)
        }
        
    }
   
    var body: some View {
        NavigationView {
            VStack {
                image
                    .resizable()
                    .frame(width: 300, height: 300)
                    .scaledToFill()
                    .foregroundColor(canLoadPhoto ? .primary : .red)
                    .padding(10)
                
                TextField("Who am I?", text: $photoName)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .focused($textFocused) .disabled(!canLoadPhoto)
                    .padding(.horizontal)
                
                HStack {
                    CustomButton(title: "Cancel") {
                        dismiss()
                    }
                   .background(.red)
                   .cornerRadius(10)
                    
                    CustomButton(title: "Save") {
                        addImageToList()
                        dismiss()
                    }
                    .background((!canLoadPhoto || photoName.isEmpty) ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .disabled(!canLoadPhoto || photoName.isEmpty)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Name your photo")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { textFocused = true }
       }
    }
    
    func addImageToList() {
        guard let inputImage = inputImage else { return }
        guard let data = inputImage.jpegData(compressionQuality: 1) else { return }
        
        var auxPhotos = photos
        
        if let index = (auxPhotos.firstIndex { $0.id == photoId }) {
            let num = index.advanced(by: 0)
            auxPhotos.remove(at: num)
        }
        
        let p = Photo(id: photoId, name: photoName, data: data)
        auxPhotos.append(p)
        
        photos = auxPhotos.sorted()
        
        saveImage()
    }
    
    func saveImage() {
        do {
            let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPhotos.json")
            let data = try JSONEncoder().encode(photos)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save photos.")
        }
    }
}
