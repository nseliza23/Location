//
//  Location.swift
//  Location
//
//  Created by student on 3/16/25.
//

import Foundation
import CoreLocation
import MapKit

@Observable
class Location: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var coordinate: CLLocationCoordinate2D
    var photos: [PhotoAsset]
    var address: String
    
    init(id: UUID, name: String, description: String, coordinate: CLLocationCoordinate2D, photos: [PhotoAsset], address: String) {
        self.id = id
        self.name = name
        self.description = description
        self.coordinate = coordinate
        self.photos = photos
        self.address = address
    }
    
    func add(asset: PhotoAsset) {
        photos.append(asset)
    }
    
    func remove(asset: PhotoAsset) {
        if let index = photos.firstIndex(of: asset) {
            asset.deleteFile()
            photos.remove(at: index)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case _name = "name"
        case _description = "description"
        case _coordinate = "coordinate"
        case _photos = "photos"
        case _address = "address"
    }
    
    //equatable conformance
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    //hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(coordinate) //refer the extensions at the bottom
        hasher.combine(photos)
        hasher.combine(address)
    }
    
    static func tempe() -> Location {
        let coordinate = CLLocationCoordinate2D(latitude: 33.4255, longitude: -111.9400)
        let tempe = Location(id: UUID(), name: "Tempe", description: "Tempe is a city in Maricopa county, Arizona, United States, with the Census Bureau reporting a 2020 population of 180,587.", coordinate: coordinate, photos: [], address: "Arizona, USA")
        return tempe
    }
}


extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {}
extension CLLocationCoordinate2D: @retroactive Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

