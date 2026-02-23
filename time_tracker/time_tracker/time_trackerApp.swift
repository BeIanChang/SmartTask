//
//  time_trackerApp.swift
//  time_tracker
//
//  Created by Ian on 2026-02-16.
//

import SwiftUI
import SwiftData

@main
struct time_trackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskModel.self,
            DailyLog.self,
            TimeEntry.self,
            TaskAttribute.self,
            TaskAttributeEntry.self,
            Milestone.self,
            ScheduleItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NotificationsManager.shared.requestAuthorization()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
