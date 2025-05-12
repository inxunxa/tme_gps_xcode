//
//  tme_gps_xcodeApp.swift
//  tme_gps_xcode
//
//  Created by Tools de México on 5/9/25.
//

import SwiftUI
import SwiftData

@main
struct tme_gps_xcodeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Client.self,
            Vendedor.self,
            Sucursal.self,
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
            MainView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
