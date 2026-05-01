//
//  HistoryView.swift
//  Again LapTracker
//
//  Created by Morgan Harris on 4/23/26.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
	@State private var vm = ViewModel()
	@Environment(\.modelContext) private var context
	
	@State private var showAlert = false

	
	@Query(sort: \Lap.startDate, order: .forward) private var allLapEntries: [Lap]
	
	var groupedLaps: [(date: Date, laps: [Lap])] {
		let grouped = Dictionary(grouping: allLapEntries) { lap in
			Calendar.current.startOfDay(for: lap.startDate)
		}
		
		return grouped
			.map { (date: $0.key, laps: $0.value) }
			.sorted { $0.date > $1.date } // newest day first
	}
	
	
    var body: some View {
		ZStack {
			Color.orangeHusk
				.ignoresSafeArea()
			
			VStack(alignment: .leading) {
				// MARK: HEADER
				HStack {
					Text("Your Track Record")
						.font(.title)
						.bold()
					
					Spacer()
					
					EditButton()
						.buttonStyle(.borderedProminent)
						.foregroundStyle(.primary)
						.overlay(
							Capsule()
								.stroke(.black, lineWidth: 2)
						)
					
					Button { showAlert = true } label: {
						Text("Clear History")
						}
						.buttonStyle(.borderedProminent)
						.foregroundStyle(.primary)
						.overlay(
							Capsule()
								.stroke(.black, lineWidth: 2)
						)
						.alert(isPresented: $showAlert) {
							Alert(
								title: Text("Are you sure you want to clear your history!?"),
								message: Text("This action cannot be undone!"),
								primaryButton: .destructive(Text("Delete")) {
									for entry in allLapEntries {
										context.delete(entry)
										try? context.save()
									}
								},
								secondaryButton: .cancel()
							)
						}
				}
				
				withAnimation(.easeInOut) {
					VStack(alignment: .center) {
						if allLapEntries.isEmpty {
							Text("...is in need of ANY WORK AT ALL")
								.bold()
						} else if allLapEntries.count <= 10 {
							Text("...could be better")
								.bold()
						} else if allLapEntries.count >= 100 {
							Text("Are you a track star?")
						} else {
							Text("...looks great!")
								.bold()
						}
					}
				}
					
				List {
					ForEach(groupedLaps, id: \.date) { group in
						Section {
							
							// Flip this list so that the latest lap shows first
							let orderedLaps = group.laps.sorted { $0.startDate > $1.startDate } // newest first

							ForEach(Array(orderedLaps.enumerated()), id: \.element.id) { index, entry in
								
								// You the real flipper
								let lapNumber = orderedLaps.count - index
								
								LapEntryView(lap: entry, lapNumber: lapNumber)
									.listRowSeparator(.hidden)
									.listRowInsets(EdgeInsets())
									.padding(.bottom)
									.listRowBackground(Color.clear)
							}
							
							
						} header: {
							Text(vm.formatDate(group.date))
								.font(.headline)
								.padding(.vertical, 4)
						}
					}
					.onDelete { indexSet in
						for index in indexSet {
							context.delete(allLapEntries[index])
						}
					}
				}
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
			}
			.padding()
		}
    }
}

extension HistoryView {
	@Observable
	final class ViewModel {
		func formatDate(_ date: Date) -> String {
			let calendar = Calendar.current
			
			if calendar.isDateInToday(date) {
				return "Today"
			} else if calendar.isDateInYesterday(date) {
				return "Yesterday"
			} else {
				let formatter = DateFormatter()
				formatter.dateStyle = .medium
				return formatter.string(from: date)
			}
		}
	}
}

