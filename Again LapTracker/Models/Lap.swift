//
//  Lap.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import Foundation
import SwiftData

@Model
class Lap {
	var id: UUID
	var startDate: Date
	var endDate: Date?
	var duration: TimeInterval
	var steps: Int
	
	init(startDate: Date) {
		self.id = UUID()
		self.startDate = startDate
		self.duration = 0
		self.steps = 0
	}
}

// MARK: Assessments

enum LapAssessment: String {
	case lightning
	case fast
	case normal
	case slow
	case snail
}

extension Lap {
	func assessLap(_ duration: TimeInterval) -> LapAssessment {
		switch duration {
			
		case ..<30:
			return .lightning
			
		case 30..<60:
			return .fast
			
		case 60..<120:
			return .normal
			
		case 120..<300:
			return .slow
			
		default:
			return .snail
		}
	}
	
	func assessmentText(for assessment: LapAssessment) -> String {
		switch assessment {
		case .lightning:
			return "You blinked and it's already over. Suspicious."
			
		case .fast:
			return "Jett would be jealous of you."
			
		case .normal:
			return "Respectable. Emotionally stable pacing."
			
		case .slow:
			return "Were you sightseeing or pacing?"
			
		case .snail:
			return "At this point you might be moving in slow motion."
		}
	}
}
