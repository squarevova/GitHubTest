//
//  GitHubTestTests.swift
//  GitHubTestTests
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import CoreData
import XCTest
@testable import GitHubTest

final class CoreDataCacheTests: XCTestCase {
    private let coreDataCache = CoreDataCache(storageType: .inMemory)

    func testSave() throws {
        let users = [
            User(id: 1, name: "name1", avatarUrl: "avatarUrl1"),
            User(id: 2, name: "name2", avatarUrl: "avatarUrl2"),
        ]
        
        coreDataCache.saveObjects(users)
        
        let cachedUsers = coreDataCache.fetchObjects()
        XCTAssertNotNil(cachedUsers)
        XCTAssertEqual(users.count, cachedUsers.count)
        
        let first = cachedUsers.first
        XCTAssertEqual(first?.id, 1)
        XCTAssertEqual(first?.name, "name1")
        XCTAssertEqual(first?.avatarUrl, "avatarUrl1")
        
        let last = cachedUsers.last
        XCTAssertEqual(last?.id, 2)
        XCTAssertEqual(last?.name, "name2")
        XCTAssertEqual(last?.avatarUrl, "avatarUrl2")
    }
}
