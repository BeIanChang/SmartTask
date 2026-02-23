import Foundation
import UserNotifications
import SwiftData

@MainActor
final class NotificationsManager {
    static let shared = NotificationsManager()

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
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
}
