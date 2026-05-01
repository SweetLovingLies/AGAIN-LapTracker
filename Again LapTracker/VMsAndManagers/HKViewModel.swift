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
//				self.fetchAllData()
			} else {
				print("\(String(describing: error))")
			}
			
		}
	}
	
	func fetchAllData() {
		guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
			return
		}
		
		let now = Date()
		let startDate = Calendar.current.startOfDay(for: now)
		
		let predicate = HKQuery.predicateForSamples(
			withStart: startDate,
			end: now,
			options: .strictStartDate
		)
		
		let query = HKStatisticsQuery(
			  quantityType: stepCountType, // the data type
			  quantitySamplePredicate: predicate, // the predicate using the set startDate and endDate
			  options: .cumulativeSum // to get the total steps
			) {
			  _, result, error in
			  guard let result = result, let sum = result.sumQuantity() else {
				print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
				return
			  }

			  let steps = Int(sum.doubleValue(for: HKUnit.count()))
			  self.todaysSteps = steps
			}
		
		
		healthStore.execute(query)
	}
	
	func fetchSteps(from start: Date, to end: Date, completion: @escaping (Int) -> Void) {
		guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
			completion(0)
			return
		}
		
		let predicate = HKQuery.predicateForSamples(
			withStart: start,
			end: end,
			options: .strictStartDate
		)
		
		let query = HKStatisticsQuery(
			quantityType: stepType,
			quantitySamplePredicate: predicate,
			options: .cumulativeSum
		) { _, result, error in
			
			guard let sum = result?.sumQuantity() else {
				completion(0)
				return
			}
			
			let steps = Int(sum.doubleValue(for: HKUnit.count()))
			completion(steps)
		}
		
		healthStore.execute(query)
	}
}
