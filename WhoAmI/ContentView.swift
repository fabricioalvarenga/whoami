//
//  ContentView.swift
//  WhoAmI
//
//  Created by FABRICIO ALVARENGA on 02/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var photos = [Photo]()
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingDetailView = false
    
    init() {
        do {
            let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPhotos.json")
            
            let data = try Data(contentsOf: savePath)
            
            let p = try JSONDecoder().decode([Photo].self, from: data)
            _photos = State(initialValue: p)
            
        } catch {
            photos = []
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(photos) { photo in
                    NavigationLink {
                        DetailView(photos: $photos, photoId: photo.id, photoName: photo.name, inputImage: photo.inputImage)
                    } label: {
                        HStack {
                            photo.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .cornerRadius(5)
                            
                            Text(photo.name)
                        }
                    }
                }
            }
            .navigationTitle("Who Am I?")
            .toolbar {
                Button {
                    showImagePicker()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .sheet(isPresented: $showingDetailView) {
                DetailView(photos: $photos, photoId: UUID(), photoName: "", inputImage: inputImage)
                
            }
            .onChange(of: inputImage) { _ in
                showDetailView()
            }
        }
    }
    
    func showDetailView() {
        guard let _ = inputImage else { return }
        showingDetailView = true
    }
    
    func showImagePicker() {
        showingImagePicker = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
