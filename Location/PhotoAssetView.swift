//
//  PhotoAssetView.swift
//  Location
//
//  Created by student on 3/18/25.
//

import SwiftUI

struct PhotoAssetView: View {
    @Binding var location: Location
    var photo: PhotoAsset
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            photo.image
                .resizable()
                .scaledToFit()
                .padding()

            Button(role: .destructive) {
                deletePhoto()
            } label: {
                Label("Delete", systemImage: "trash")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
    }

    func deletePhoto() {
        location.remove(asset: photo)
        presentationMode.wrappedValue.dismiss()
    }
}
