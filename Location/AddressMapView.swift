//
//  AddressMapView.swift
//  Location
//
//  Created by student on 3/18/25.
//

import SwiftUI
import MapKit

struct AddressMapView: View {
    @Binding var location: Location
    @State private var searchAddress = ""
//    @State private var searchText: String = ""
    @State private var foundItems: [MKMapItem] = []
    @State private var selectedItem: MKMapItem?
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.4255, longitude: -111.9400), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    @FocusState private var isSearchFieldFocus: Bool
    
    var body: some View {
        VStack {
            Section(header: Text("Address").font(.largeTitle)) {
                TextField("Search Address", text: $searchAddress)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        submitSearch()
                    }
                if !foundItems.isEmpty {
                    List(selection: $selectedItem) {
                        ForEach(foundItems, id: \.self) { item in
                            let name = item.name ?? "-no-name-"
                            Text(name)
                            HStack {
                                Text(item.placemark.subThoroughfare ?? "")
                                Text(item.placemark.thoroughfare ?? "")
                                Text(item.placemark.subLocality ?? "")
                                Text(item.placemark.locality ?? "")
                                Text(item.placemark.administrativeArea ?? "")
                                Text(item.placemark.postalCode ?? "")
                                Text(item.placemark.country ?? "")
                            }
                            .font(.caption)
                        }
                    }
                }
                //            Map(position: $locator.position)
                Map(position: $position)
            }
            .padding()
            .onChange(of: selectedItem) {
                if let selectedItem {
                    position = MapCameraPosition.region(MKCoordinateRegion(center: selectedItem.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                    foundItems = []
                    location.coordinate = selectedItem.placemark.coordinate
                    location.address = (selectedItem.placemark.subThoroughfare ?? "") + " " + (selectedItem.placemark.thoroughfare ?? "") + " "
                        + (selectedItem.placemark.subLocality ?? "") + " "
                        + (selectedItem.placemark.locality ?? "") + " "
                        + (selectedItem.placemark.administrativeArea ?? "") + " "
                        + (selectedItem.placemark.postalCode ?? "") + " "
                    + (selectedItem.placemark.country ?? "")
                    print(selectedItem.placemark.coordinate)
                }
            }
        }
    }
    
    func submitSearch() {
        Task {
            print("submit")
            await runSearch(text: searchAddress)
        }
    }
    
    func runSearch(text: String) async {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        let search = MKLocalSearch(request: searchRequest)
        do {
            let response = try await search.start()
            print("response count \(response.mapItems.count)")
            foundItems = response.mapItems
        }
        catch {
            print(error)
        }
    }
    
}

#Preview {
    @Previewable @State var location = Location.tempe()
    AddressMapView(location: $location)
}
