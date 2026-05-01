//
//  LapManager.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//


@Observable
final class LapManager {
    var laps: [Lap] = []
    let health = HKViewModel()
    
    func finalizeLap(_ lap: Lap) {
        health.fetchSteps(from: lap.startDate, to: Date()) { steps in
            DispatchQueue.main.async {
                lap.steps = steps
                lap.endDate = Date()
            }
        }
    }
}