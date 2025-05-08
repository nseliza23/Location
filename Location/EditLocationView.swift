//
//  EditLocationView.swift
//  Location
//
//  Created by student on 3/16/25.
//

import SwiftUI
import PhotosUI
import MapKit
import CoreLocation

struct EditLocationView: View {
    @State var location: Location
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var locationName = ""
    @State private var locationDescription = ""
    @State private var locationAddress = "Edit Address"
    private var mapPosition: MapCameraPosition {
        MapCameraPosition.region(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    var locator = Locator()
//    @State private var pin = MKAnnotation()

    var body: some View {
        VStack {
            Form {
                Section("Location Name") {
                    TextField("Location Name", text: $location.name)
                }
                Section("Location Description") { //could replace with textEditor to resize and show full desc
                    TextEditor(text: $location.description)
                        .frame(minHeight: 100)
                }
                Section("Address") {
                    NavigationLink(destination: AddressMapView(location: $location), label: {
                        Text(location.address)})
                }
                Section("Map") {
                    Map(position: .constant(mapPosition))
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .disabled(true)
                }
                Section("Photos") {
                    VStack(alignment: .leading) {
                        PhotosPicker(selection: $selectedItems, matching: .images) {
                            Label("Add Photo", systemImage: "photo.fill.on.rectangle.fill")
                        }
                    }
                    
                    if !location.photos.isEmpty {
                        PhotosGridView(location: $location)
                    }
                }
            }
        }
        .navigationTitle("Location")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            locator.start()
//        }
        .onChange(of: selectedItems) {
            importSelectedPhotos()
        }
        //        .navigationDestination(for: PhotoAsset.self) { asset in
        //            PhotoAssetView(photo: asset)
        //        }
    }
    
    func importSelectedPhotos() {
        Task {
            for item in selectedItems {
                if let asset = try? await item.loadTransferable(type: PhotoAsset.self) {
                    location.add(asset: asset)
                }
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        EditLocationView(location: Location.tempe(), locator: Locator())
    }
}
