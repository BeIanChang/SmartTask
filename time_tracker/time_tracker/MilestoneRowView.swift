import SwiftUI

struct MilestoneRowView: View {
    @Bindable var milestone: Milestone

    var body: some View {
        HStack(spacing: 12) {
            Button {
                milestone.isCompleted.toggle()
            } label: {
                Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(milestone.isCompleted ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.body)

                if let deadline = milestone.deadline {
                    Text(deadline, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
    }
}
