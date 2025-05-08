//
//  LocationApp.swift
//  Location
//
//  Created by student on 3/16/25.
//

import SwiftUI

@main
struct LocationApp: App {
    @State private var store: LocationStore
    
    init() {
        do {
            self.store = try LocationStore.load(fileName: "Locations")
        }
        catch {
            print(error)
            self.store = LocationStore()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
