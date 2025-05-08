//
//  PhotosGridView.swift
//  Location
//
//  Created by student on 3/18/25.
//

import SwiftUI

struct PhotosGridView: View {
    @Binding var location: Location
    private let gridSize: CGFloat = 80
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: gridSize), spacing: 2)]
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(location.photos) { asset in
                    NavigationLink(destination: PhotoAssetView(location: $location, photo: asset)) {
                        asset.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: gridSize, height: gridSize)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
        }
    }
}


#Preview {
//    PhotosGridView()
}

