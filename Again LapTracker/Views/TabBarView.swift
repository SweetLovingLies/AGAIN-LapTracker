//
//  TabBarView.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import SwiftData
import SwiftUI

struct TabBarView: View {
	@State private var selection: Int = 1
	@State private var currentScreen: Route = .timerView

	var body: some View {
		VStack(spacing: 0) {
			ZStack {
				Group {
					switch currentScreen {
					case .timerView:
						ContentView()
					case .historyView:
						HistoryView()
					}
				}
			}

			ZStack {
				Rectangle()
					.ignoresSafeArea()
					.foregroundStyle(.orangeHusk)

				HStack {
					Group {
						Button {
							currentScreen = .timerView
						} label: {
							VStack(alignment: .center) {
								Image(systemName: "timer")
								Text("AGAIN!")
										Capsule()
											.frame(width: currentScreen == .timerView ? 80 : 0, height: 2)
											.foregroundStyle(.accent)
											.shadow(color: .black, radius: 0, y: 0.8)
							}
							.frame(width: 100)
						}
						
						Spacer()
							.frame(width: 100)

						Button {
							currentScreen = .historyView
						} label: {
							VStack(alignment: .center) {
								Image(systemName: "archivebox")
								Text("History")
										Capsule()
											.frame(width: currentScreen == .historyView ? 80 : 0, height: 2)
											.foregroundStyle(.accent)
											.shadow(color: .black, radius: 0, y: 0.8)
							}
							.frame(width: 100)
						}
					}
					.foregroundStyle(.primary)
				}

			}
			.frame(height: 60)
		}
	}
}

//#Preview {
//	let container = try! ModelContainer(
//		for: Lap.self,
//		configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//	)
//
//	let lap1 = Lap(
//		startDate: .now,
//		duration: .infinity,
//		steps: 10
//	)
//	let lap2 = Lap(
//		startDate: .now,
//		duration: .infinity,
//		steps: 50
//	)
//	let lap3 = Lap(
//		startDate: .now,
//		duration: .infinity,
//		steps: 100
//	)
//
//	let lap4 = Lap(
//		startDate: .distantPast,
//		duration: .infinity,
//		steps: 2000
//	)
//
//
//
//	container.mainContext.insert(lap1)
//	container.mainContext.insert(lap2)
//	container.mainContext.insert(lap3)
//	container.mainContext.insert(lap4)
//
//	return TabBarView()
//		.modelContainer(container)
//		.environment(\.modelContext, container.mainContext)
////}
