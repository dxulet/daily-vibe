import SwiftUI

struct SettingsScreen: View {
    @State private var vm = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var vm = vm

        return NavigationStack {
            List {
                Section {
                    Toggle("Show Daily Vibe prompts", isOn: $vm.isVibeEnabled)
                } footer: {
                    Text("When off, you won't see the daily theme on your notification or feed.")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.vibeBackground)
            .navigationTitle("Daily Vibe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .vibeToolbarStyling()
        }
        .presentationDetents([.large])
        .interactiveDismissDisabled()
    }
}

#Preview {
    Color.gray.sheet(isPresented: .constant(true)) {
        SettingsScreen()
    }
    .preferredColorScheme(.dark)
    .previewEnvironments()
}
