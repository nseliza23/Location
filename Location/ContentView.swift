//
//  ContentView.swift
//  Location
//
//  Created by student on 3/16/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(LocationStore.self) private var store
    @State private var showingAddLocation = false
    @State private var locationName = ""
    @State private var locationDescription = ""
    @State private var locationAddress = ""
    @State var locator = Locator()
//    @State private var assetDemo: PhotoAsset = PhotoAsset.debugPhotoAsset()
    var body: some View {
        NavigationStack {
                List {
                    ForEach(store.locations) { item in
                        NavigationLink(destination: EditLocationView(location: item)) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.description)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: deleteLocation)
                    .onMove(perform: moveLocation)
                }
            .navigationDestination(for: Location.self) { item in
                EditLocationView(location: item)
            }
            .navigationTitle("Locations")
            .toolbar {
                Button("Add") {
                    showingAddLocation = true
                }
                
                EditButton()
//                Button(action: {
//                    let location = Location(id: UUID(), name: "Location Name", description: "Location Description", coordinate: CLLocationCoordinate2D(latitude: 70, longitude: -111), photos: [])
//                    store.add(location: location)
//                    archive()
//                }, label: {
//                    Text("Add")
//                })
            }
            .onAppear {
                locator.start()
                archive()
            }
        }
        .sheet(isPresented: $showingAddLocation) {
            addLocationSheet
        }
    }
    
    var addLocationSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Enter Location Details")) {
                    TextField("Location Name: ", text: $locationName)
                    TextField("Location Description: ", text: $locationDescription)
                }
            }
            .navigationTitle("Add New Location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAddLocation = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addLocation()
                        showingAddLocation = false
                    }
                    .disabled(locationName.isEmpty)
                }
            }
        }
    }
    
    func archive() {
        print("archive")
        do {
            try LocationStore.save(fileName: "Locations", store: store)
        }
        catch {
            print(error)
        }
    }
    
    func addLocation() {
        let location = Location(id: UUID(), name: locationName, description: locationDescription, coordinate: CLLocationCoordinate2D(latitude: 70, longitude: -111), photos: [], address: locationAddress)
        store.add(location: location)
        archive()
        
        locationName = ""
        locationDescription = ""
    }
    
    func deleteLocation(at offsets: IndexSet) {
        store.delete(at: offsets)
        archive()
    }
    
    //move doesnt work unless in edit more - FIX
    func moveLocation(from source: IndexSet, to destination: Int) {
        store.move(fromOffsets: source, toOffset: destination)
        archive()
    }
}

#Preview {
    ContentView()
        .environment(LocationStore())
}
