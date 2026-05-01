//
//  LapEntryView.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import SwiftUI

struct LapEntryView: View {
	let lap: Lap
	let lapNumber: Int
	
    var body: some View {
		ZStack(alignment: .leading) {
			Color.accent
			VStack(alignment: .leading) {
				HStack {
					Text("\(ordinal(lapNumber)) lap of the day")
						.font(.title2)
						.bold()
					
					Spacer()
					
					Text("\(lap.startDate.formatted())")
						.font(.headline)
				}
				
				VStack(alignment: .leading) {
					HStack {
						Text("Duration:")
						Text("\(lap.duration, format: .number.precision(.fractionLength(2)))")
							.underline()
					}
					
//					HStack {
//						Text("Steps Taken:")
//						Text("\(lap.steps)")
//							.underline()
//					}
				}
				
				Rectangle()
					.frame(height: 1)
				
				
				let assessment = lap.assessLap(lap.duration)
				
				Text("Assessment:")
					.font(.title3)
					.bold()
				
				Text(lap.assessmentText(for: assessment))
				
			}
			.padding()
			.border(.black, width: 3)
			
			
		}
    }
}

extension LapEntryView {
	func ordinal(_ number: Int) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .ordinal
		return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
	}
}
