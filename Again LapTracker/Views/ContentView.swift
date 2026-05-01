//
//  ContentView.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var context
	@State private var vm = ViewModel()
	
	// MARK: Timer Stuff
	@State private var startTime: Date?
	@State private var accumulatedTime: TimeInterval = 0
	@State private var isRunning = false
	
	var currentTime: TimeInterval {
		if let start = startTime {
			return accumulatedTime + Date().timeIntervalSince(start)
		}
		return accumulatedTime
	}
	
	// MARK: States of Main Button
	var hasStarted: Bool {
		startTime != nil || accumulatedTime > 0
	}

	var isPaused: Bool {
		!isRunning && hasStarted
	}
	
	var mainButtonTitle: String {
		if isRunning {
			return "Next Lap"
		} else if isPaused {
			return "Resume"
		} else {
			return "Start"
		}
	}
	
	// MARK: LAPS
	@State private var currentLap: Lap?
	@State private var lapManager = LapManager()
	@State private var hasActiveLap = false
	
	
    var body: some View {
		ZStack {
			Color.orangeHusk.ignoresSafeArea()
			
			VStack {
				Image(.simpleLogo)
					.resizable()
					.scaledToFit()
					.frame(width: 200)
				
				HStack {
					withAnimation(.easeInOut) {
						TimelineView(.periodic(from: .now, by: 0.1)) { _ in
							Text(vm.formatTime(currentTime))
								.font(.system(.title, design: .monospaced))
						}
						.padding(.vertical)
					}
					
				}
				.frame(width: 300)
				.background(.accent)
				.clipShape(.capsule)
				.shadow(color: .black, radius: 0, y: 7)
				
				.overlay(
					Capsule()
						.stroke(.black, lineWidth: 3)
				)
				.padding(.bottom, 10)
				
				Group {
					Button {
						// NEXT LAP
						if isRunning {
							guard let lap = currentLap else { return }

							lap.duration = currentTime

							lapManager.finalizeLap(lap)

							// start next lap immediately
							accumulatedTime = 0
							startTime = Date()

							let newLap = Lap(startDate: Date())
							context.insert(newLap)
							currentLap = newLap

							isRunning = true
							try? context.save()
						}

						// RESUME
						
						if currentLap == nil {
							let lap = Lap(startDate: Date())
							context.insert(lap)
							currentLap = lap
						}

						startTime = Date()
						isRunning = true

					} label: {
						Text(mainButtonTitle)
					}
					.frame(width: 200, height: 50)
					.background(.accent)
					.clipShape(.capsule)
					.foregroundStyle(.primary)
					.bold()
					.overlay(
						Capsule()
							.stroke(.black, lineWidth: 3)
					)
					.contentShape(.capsule)
					
					HStack {
						Group {
							
							// Pause Button
							Button {
								if let start = startTime {
									accumulatedTime += Date().timeIntervalSince(start)
								}
								isRunning = false
								startTime = nil
							} label: {
								Text("Pause")
							}
							
							// Stop Button
							Button {
								if let lap = currentLap {
									
									lap.duration = currentTime
									
									lapManager.finalizeLap(lap)
								}
								
								try? context.save()
								
								currentLap = nil
								startTime = nil
								accumulatedTime = 0
								isRunning = false
								
							} label: {
								Text("Stop")
							}
							
							
						}
//						.font(.headline)
						.buttonStyle(.borderedProminent)
						.foregroundStyle(.primary)
						.overlay(
							Capsule()
								.stroke(.black, lineWidth: 2)
						)
					}
					
				}
				
				
				
			}
		}
    }
}


extension ContentView {
	@Observable
	final class ViewModel {
		func formatTime(_ time: TimeInterval) -> String {
			let minutes = Int(time) / 60
			let seconds = Int(time) % 60
			let hundredths = Int((time * 100).truncatingRemainder(dividingBy: 100))
			
			return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
		}
	}
}
