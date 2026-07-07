import Foundation

struct Walk: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var petName: String
    var durationMinutes: Double
    var distanceKM: Double
    var date: Date = Date()
}
