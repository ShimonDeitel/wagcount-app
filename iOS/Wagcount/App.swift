import SwiftUI

@main
struct WagcountApp: App {
    @StateObject private var store = WagcountStore()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .tint(Theme.accent)
        }
    }
}
