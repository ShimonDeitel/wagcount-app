import XCTest
@testable import Wagcount

final class WagcountTests: XCTestCase {
    var store: WagcountStore!

    override func setUp() {
        super.setUp()
        store = WagcountStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.walks.count, WagcountStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.walks.count
        let added = store.add(Walk(petName: "P", durationMinutes: 10, distanceKM: 1), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.walks.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.walks.count < WagcountStore.freeTierLimit {
            _ = store.add(Walk(petName: "P", durationMinutes: 10, distanceKM: 1), isPro: false)
        }
        let blocked = store.add(Walk(petName: "P", durationMinutes: 10, distanceKM: 1), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.walks.count < WagcountStore.freeTierLimit {
            _ = store.add(Walk(petName: "P", durationMinutes: 10, distanceKM: 1), isPro: false)
        }
        let allowed = store.add(Walk(petName: "P", durationMinutes: 10, distanceKM: 1), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.walks.count < WagcountStore.freeTierLimit {
            _ = store.add(Walk(petName: "P", durationMinutes: 10, distanceKM: 1), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(Walk(petName: "P", durationMinutes: 10, distanceKM: 1), isPro: false)
        let before = store.walks.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.walks.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.walks.count
        let reloaded = WagcountStore()
        XCTAssertEqual(reloaded.walks.count, count)
    }
}
