//
//  HKViewModel.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import Foundation
import SwiftData
import HealthKit

@Observable
final class HKViewModel {
	var todaysSteps: Int = 0
	let healthStore = HKHealthStore()
	
	init() {
		requestAuthorization()
		
//		debugTodaySteps()
	}
	
	func requestAuthorization() {
		let toRead = Set([
			HKObjectType.quantityType(forIdentifier: .stepCount)!
		])
		
		guard HKHealthStore.isHealthDataAvailable() else {
			print("HealthKit data is not available!")
			return
		}
		
		healthStore.requestAuthorization(toShare: nil, read: toRead) { success, error in
			if success {
				print("HealthKit auth success:", success)
			} else {
				print("\(String(describing: error))")
			}
		}
	}
	
	func debugTodaySteps() {
		let now = Date()
		let start = Calendar.current.startOfDay(for: now)
		
		fetchSteps(from: start, to: now) { steps in
			print("TODAY STEPS:", steps)
		}
	}
	
	
	func fetchSteps(from start: Date, to end: Date, completion: @escaping (Int) -> Void) {
		guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
			print("StepCount not found.")
			completion(0)
			return
		}
		
		let predicate = HKQuery.predicateForSamples(
			withStart: start,
			end: end,
			options: .strictEndDate
		)
		
		let query = HKStatisticsQuery(
			quantityType: stepType,
			quantitySamplePredicate: predicate,
			options: .cumulativeSum
		){ _, result, error in
			
			print("Result:", result)
			
			guard let sum = result?.sumQuantity() else {
				print("There is no result.")
				completion(0)
				return
			}
			
			let steps = Int(sum.doubleValue(for: HKUnit.count()))
			
			completion(steps)
		}
		
		healthStore.execute(query)
	}
}
