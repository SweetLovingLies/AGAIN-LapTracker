//
//  Again_LapTrackerApp.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import SwiftUI
import SwiftData

@main
struct Again_LapTrackerApp: App {
	let modelContainer: ModelContainer
	
	init() {
		do {
			modelContainer = try ModelContainer(
				for: Lap.self
			)
		} catch {
			fatalError("Failed to initialize SwiftData container: \(error.localizedDescription)")
		}
	}
	
    var body: some Scene {
        WindowGroup {
            TabBarView()
				.modelContainer(modelContainer)
        }
    }
}
