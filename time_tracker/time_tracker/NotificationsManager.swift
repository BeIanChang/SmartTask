import Foundation
import UserNotifications
import SwiftData
#if canImport(ActivityKit) && !os(macOS)
import ActivityKit
#endif

@MainActor
final class NotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationsManager()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }


    func scheduleMilestoneNotification(_ milestone: Milestone) {
        guard let deadline = milestone.deadline else { return }
        let triggerDate = Calendar.current.date(byAdding: .hour, value: -24, to: deadline) ?? deadline
        guard triggerDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Milestone due soon"
        content.body = milestone.title
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: milestoneNotificationId(for: milestone), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func removeMilestoneNotification(_ milestone: Milestone) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [milestoneNotificationId(for: milestone)])
    }


    private func milestoneNotificationId(for milestone: Milestone) -> String {
        "milestone-\(milestone.persistentModelID)"
    }


#if canImport(ActivityKit) && !os(macOS)
    func startTimerActivity(for task: TaskModel) {
        if #available(iOS 16.1, *) {
            let attributes = SmartTaskLiveActivityAttributes(taskId: String(describing: task.persistentModelID))
            let state = SmartTaskLiveActivityAttributes.ContentState(taskTitle: task.title, startedAt: task.runningStartAt ?? Date())
            let content = ActivityContent(state: state, staleDate: nil)
            do {
                _ = try Activity<SmartTaskLiveActivityAttributes>.request(attributes: attributes, content: content, pushType: nil)
            } catch {
                return
            }
        }
    }

    func stopTimerActivity() {
        Task {
            if #available(iOS 16.1, *) {
                for activity in Activity<SmartTaskLiveActivityAttributes>.activities {
                    await activity.end(nil, dismissalPolicy: .immediate)
                }
            }
        }
    }
#endif
}
