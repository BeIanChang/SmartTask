# SmartTask

SmartTask is a minimal, local‑only iPhone app for daily goal logging. It favors speed and clarity over automation: mark what you did today, record rough time, and optionally track custom attributes for deeper goals.

The app is built to stay simple: no timers you must manage, no background tracking, and no cloud accounts. Just quick logging, clear history, and lightweight stats.

## Features
- Today logging with one‑tap completion, timer start/pause, and manual minutes.
- Milestones with deadlines and completion toggles.
- Weekly goal summaries derived from task attributes.
- Calendar view with week strip and timeline blocks.
- History edits for past days.
- Task detail stats with consistency dots and trends.
- Custom attributes (number or percent) with weekly goals and daily targets.
- Notes per time entry.
- Fully local storage (SwiftData).

## Screens
- **Today**: milestones, weekly goals, and daily task rows with timer and minutes.
- **Calendar**: weekly strip plus timeline view of recorded time and schedule blocks.
- **History**: edit past logs and minutes for any date.
- **Task Detail**: trends, totals, and per‑task stats.
- **About**: author info.

## Data Model
- `TaskModel`: task title, archive flag, last minutes, running timer state.
- `DailyLog`: per‑day manual minutes and completion.
- `TimeEntry`: timer sessions with notes.
- `TaskAttribute`: custom numeric/percent attributes with weekly goals.
- `TaskAttributeEntry`: per‑day attribute values.
- `Milestone`: larger goals with optional deadlines.
- `ScheduleItem`: manual calendar blocks (meetings, focus sessions).

## Tech Stack
- **SwiftUI** for UI
- **SwiftData** for local persistence
- **Swift Charts** for trend visualization
- **UserNotifications** for milestone alerts

## Getting Started
1. Open `time_tracker/time_tracker.xcodeproj` in Xcode.
2. Select a simulator or device.
3. Build and run (`⌘R`).

## Notifications
- Milestone reminders fire 24 hours before deadline.
- Live Activity timer status is planned (widget target required).

## Roadmap
- Live Activity lock‑screen timer controls.
- Richer calendar layout with colored blocks and drag edits.
- Goal insights and streak summaries.
- Widgets.
