//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by FABRICIO ALVARENGA on 26/09/22.
//

import Foundation

extension EditView {
    @MainActor final class ViewModel: ObservableObject {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var location: Location?
        @Published var name: String
        @Published var description: String

        @Published var loadingState = LoadingState.loading

        @Published var pages = [Page]()
        
        init() {
            _name = Published(initialValue: location?.name ?? "Unknown place")
            _description = Published(initialValue: location?.description ?? "")
        }
        
        func setLocation(to location: Location) {
            _name = Published(wrappedValue: location.name)
            _description = Published(wrappedValue: location.description)

            self.location = location
        }
        
        func newLocation() -> Location? {
            guard let place = location else { return nil }
            
            var newPlace = place
            newPlace.id = UUID()
            newPlace.name = name
            newPlace.description = description
            return newPlace
        }

        func fetchNearbyPlaces() async {
            guard let location = location else { return }
            
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }

    }
}
