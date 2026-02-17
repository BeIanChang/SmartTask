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

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Task.self, DailyLog.self], inMemory: true)
}
