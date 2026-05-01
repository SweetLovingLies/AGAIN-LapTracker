//
//  LapManager.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import Foundation
import HealthKit
import SwiftData

@Observable
final class LapManager {
	var laps: [Lap] = []
	let health = HKViewModel()

	func finalizeLap(_ lap: Lap) {

		print("Finalizing lap")

		let endDate = Date()  // capture once

		// small delay to let HealthKit catch up
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let safeStart = lap.startDate.addingTimeInterval(-10)

			self.health.fetchSteps(from: safeStart, to: endDate) { steps in
				print("Steps:", steps)

				DispatchQueue.main.async {
					lap.steps = steps
					lap.endDate = endDate
				}
			}
		}
	}
}
