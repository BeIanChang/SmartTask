import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Author") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("BeIanChang")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("beianchang@users.noreply.github.com")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Github")
                        Spacer()
                        Text("https://github.com/BeIanChang")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Portfolio")
                        Spacer()
                        Text("https://yangyang-portfolio.netlify.app/")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("About")
        }
    }
}
