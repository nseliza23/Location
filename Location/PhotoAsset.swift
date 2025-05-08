//
//  PhotoAsset.swift
//  Location
//
//  Created by student on 3/16/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class PhotoAsset: Codable, Hashable, Identifiable {
    let id: UUID
    var url: URL //url of the image file that got added to our app
    var contentType: UTType //jpg png etc
    var absoluteURL: URL {
        let documentsDirectionURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsDirectionURL!.appending(component: url.path()) //wrapping?
    } //using first element in array to return; optional wrapping
    
    var uiImage: UIImage {
        if let img = UIImage(contentsOfFile: absoluteURL.path()) {
            return img
        }
        else {
            return UIImage(systemName: "photo")!
        }
    }
    
    var image: Image {
        return Image(uiImage: uiImage)
    }
    
    init(id: UUID, url: URL, contentType: UTType) {
        self.id = id
        self.url = url
        self.contentType = contentType
    }
    
    static func debugPhotoAsset() -> PhotoAsset {
//        let asset = PhotoAsset(id: UUID(), url: URL(string: "photoAsset.jpg")!, contentType: UTType.jpg)
        guard let bundleUrl = Bundle.main.url(forResource: "photoAsset.jpg", withExtension: nil) else {
            return PhotoAsset(id: UUID(), url: URL(string: "photoAsset.jpg")!, contentType: UTType.jpeg)
        }
//            fatalError("Failed to locate \(file) in bundle.")
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationUrl = documentsDirectoryURL!.appending(component: "photoAsset.jpg")
            try! FileManager.default.copyItem(at: bundleUrl, to: destinationUrl)
            let asset = PhotoAsset(id: UUID(), url: URL(string: "photoAsset.jpg")!, contentType: UTType.jpeg)
            return asset
    }
    
    //equatable conformance
    static func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool{
        lhs.id == rhs.id
    }
    
    //hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
        hasher.combine(contentType)
    }
}


extension PhotoAsset: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(importedContentType: .jpeg, importing: { received in
            return PhotoAsset.copyReceivedFile(received, contentType: .jpeg)
        })
        FileRepresentation(importedContentType: .png, importing: { received in
            return PhotoAsset.copyReceivedFile(received, contentType: .png)
        })
        FileRepresentation(importedContentType: .heic, importing: { received in
            return PhotoAsset.copyReceivedFile(received, contentType: .heic)
        })
    }
    
    static func copyReceivedFile(_ received: ReceivedTransferredFile, contentType: UTType) -> PhotoAsset {
        //construct url to be used by PhotoAsset
        let now = Date().formatted(Date.ISO8601FormatStyle().timeSeparator(.omitted))
        let name = "\(now)-\(received.file.lastPathComponent)"
        guard let assetUrl = URL(string: name) else {
            return PhotoAsset(id: UUID(), url: URL(string: "missing")!, contentType: .jpeg)
        }
        
        //construct url to copy received file
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsDirectoryURL!.appending(path: assetUrl.path())
        
        //actually copy the file into our Documents folder
        try? FileManager.default.copyItem(at: received.file, to: destinationUrl)
        
        //return the PhotoAsset
        return PhotoAsset(id: UUID(), url: assetUrl, contentType: .jpeg)
    }
    
    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: absoluteURL)
        }
        catch {
            print(error)
        }
    }
}


