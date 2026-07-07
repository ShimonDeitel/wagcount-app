import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: WagcountStore
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.walks) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.petName).font(Theme.headlineFont)
                        Text("\(entry.durationMinutes)")
                            .font(Theme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { store.remove(at: $0) }
            }
            .navigationTitle("Wagcount")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showingSettings = true } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("main.settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAdd(isPro: purchases.isPro) {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("main.addButton")
                }
            }
            .sheet(isPresented: $showingAdd) { AddWalkView() }
            .sheet(isPresented: $showingPaywall) { PaywallView() }
            .sheet(isPresented: $showingSettings) { SettingsView() }
        }
    }
}

struct AddWalkView: View {
    @EnvironmentObject var store: WagcountStore
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var petName = ""
    @State private var durationMinutes = ""
    @State private var distanceKM = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Pet Name", text: $petName)
                        .accessibilityIdentifier("addWalk.petNameField")
                    TextField("Duration (min)", text: $durationMinutes).keyboardType(.decimalPad)
                    TextField("Distance (km)", text: $distanceKM).keyboardType(.decimalPad)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { hideKeyboard() }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let entry = Walk(petName: petName.isEmpty ? "Pet Name" : petName, durationMinutes: Double(durationMinutes) ?? 0, distanceKM: Double(distanceKM) ?? 0)
                        _ = store.add(entry, isPro: purchases.isPro)
                        dismiss()
                    }
                    .accessibilityIdentifier("addWalk.saveButton")
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
