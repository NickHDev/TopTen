//
//  TopTenVer2App.swift
//  TopTenVer2
//
//  Created by Nicholas M Hieb on 6/29/25.
//

import SwiftUI
import SwiftData

@main
struct TopTenVer2App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ListItem.self,
            ListEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
