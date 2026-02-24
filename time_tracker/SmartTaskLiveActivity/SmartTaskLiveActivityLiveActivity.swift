//
//  SmartTaskLiveActivityLiveActivity.swift
//  SmartTaskLiveActivity
//
//  Created by Ian on 2026-02-24.
//

#if canImport(ActivityKit) && !os(macOS)
import ActivityKit
import WidgetKit
import SwiftUI

struct SmartTaskLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SmartTaskLiveActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                Text(context.state.taskTitle)
                    .font(.headline)
                Text(timerText(from: context.state.startedAt))
                    .font(.title2.monospacedDigit())
            }
            .padding()
            .activityBackgroundTint(Color(.secondarySystemBackground))
            .activitySystemActionForegroundColor(.primary)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Running")
                        .font(.caption)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerText(from: context.state.startedAt))
                        .font(.caption.monospacedDigit())
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.taskTitle)
                        .font(.caption)
                }
            } compactLeading: {
                Text("⏱")
            } compactTrailing: {
                Text(timerText(from: context.state.startedAt))
                    .font(.caption2.monospacedDigit())
            } minimal: {
                Text("⏱")
            }
        }
    }
}

private func timerText(from start: Date) -> String {
    let elapsed = Int(Date().timeIntervalSince(start))
    let hours = elapsed / 3600
    let minutes = (elapsed % 3600) / 60
    let seconds = elapsed % 60
    if hours > 0 {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    return String(format: "%02d:%02d", minutes, seconds)
}

#Preview("Notification", as: .content, using: SmartTaskLiveActivityAttributes(taskId: "preview")) {
    SmartTaskLiveActivityLiveActivity()
} contentStates: {
    SmartTaskLiveActivityAttributes.ContentState(taskTitle: "Preview Task", startedAt: Date())
}
#endif
