//
//  EditView.swift
//  BucketList
//
//  Created by FABRICIO ALVARENGA on 26/09/22.
//

import SwiftUI

struct EditView: View {
    @StateObject private var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss

    private var location: Location
    private var onSave: (Location?) -> Void
    
    init(location: Location, onSave: @escaping (Location?) -> Void) {
        self.onSave = onSave
        self.location = location
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description:", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    onSave(viewModel.newLocation())
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
            .onAppear {
                viewModel.setLocation(to: location)
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
