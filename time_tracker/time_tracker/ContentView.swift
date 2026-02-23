//
//  ContentView.swift
//  time_tracker
//
//  Created by Ian on 2026-02-16.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "checkmark.circle")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TaskModel.self, DailyLog.self, TimeEntry.self, TaskAttribute.self, TaskAttributeEntry.self, Milestone.self, ScheduleItem.self], inMemory: true)
}
