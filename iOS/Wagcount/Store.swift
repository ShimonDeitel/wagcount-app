import Foundation
import Combine

final class WagcountStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var walks: [Walk] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("wagcountstore.json")
        load()
    }

    var isAtFreeLimit: Bool { walks.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || walks.count < Self.freeTierLimit
    }

    func add(_ entry: Walk, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        walks.append(entry)
        return true
    }

    func remove(at offsets: IndexSet) {
        walks.remove(atOffsets: offsets)
    }

    func update(_ entry: Walk) {
        if let idx = walks.firstIndex(where: { $0.id == entry.id }) {
            walks[idx] = entry
        }
    }

    private func seedIfNeeded() {
        if walks.isEmpty {
            walks = [Self.sampleSeed]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(walks: walks)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.walks = state.walks
            
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var walks: [Walk]
        
    }
    static let sampleSeed = Walk(petName: "Buddy", durationMinutes: 30, distanceKM: 2.0, date: Date())
}
