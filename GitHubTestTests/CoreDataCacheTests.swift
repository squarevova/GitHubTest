//
//  CoreDataCacheTests.swift
//  GitHubTestTests
//
//  Created by Volodymyr Milichenko on 11/07/2024.
//

import XCTest
@testable import GitHubTest

final class CoreDataCacheTests: XCTestCase {
    private var cache: some CacheType<User> = CoreDataCache(storageType: .inMemory)

    func testCoreDataSaveAndRestore() throws {
        let users = [
            User(
                id: 1,
                name: "name1",
                avatarUrl: "avatarUrl1",
                followersUrl: "https://followers1.com",
                reposUrl: "https://repos1.com"
            ),
            User(
                id: 2,
                name: "name2",
                avatarUrl: "avatarUrl2",
                followersUrl: "https://followers2.com",
                reposUrl: "https://repos2.com"
            )
        ]
        
        cache.saveObjects(users)
        
        let cachedItems = cache.loadObjects()?.sorted(by: { $0.id < $1.id })
        XCTAssertNotNil(cachedItems)
        XCTAssertEqual(users.count, cachedItems!.count)
        
        let first = cachedItems!.first
        XCTAssertNotNil(first)
        XCTAssertEqual(first?.id, 1)
        XCTAssertEqual(first?.name, "name1")
        XCTAssertEqual(first?.avatarUrl, "avatarUrl1")
        XCTAssertEqual(first?.followersUrl, "https://followers1.com")
        XCTAssertEqual(first?.reposUrl, "https://repos1.com")
        
        let second = cachedItems!.last
        XCTAssertNotNil(second)
        XCTAssertEqual(second?.id, 2)
        XCTAssertEqual(second?.name, "name2")
        XCTAssertEqual(second?.avatarUrl, "avatarUrl2")
        XCTAssertEqual(second?.followersUrl, "https://followers2.com")
        XCTAssertEqual(second?.reposUrl, "https://repos2.com")
    }
}
