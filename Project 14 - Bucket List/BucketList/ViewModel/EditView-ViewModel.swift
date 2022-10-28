//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Pham Anh Tuan on 10/28/22.
//

import Foundation

enum LoadingState {
    case loading, loaded, failed
}

extension EditView {
    @MainActor class ViewModel: ObservableObject {
        var location: Location
        var onSave: (Location) -> Void
        
        @Published var name: String
        @Published var description: String
        @Published private(set) var pages = [Page]()
        @Published private(set) var loadingState = LoadingState.loading
        
        init(location: Location, onSave: @escaping (Location) -> Void) {
            self.location = location
            self.onSave = onSave
            self.name = location.name
            self.description = location.description
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)

                // success – convert the array values to our pages array
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
        
        func save(action: () -> Void) {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description

            onSave(newLocation)
            action()
        }
    }
}
