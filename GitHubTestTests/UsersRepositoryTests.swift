//
//  ForecastRepositoryTests.swift
//  OpenWeatherExampleTests
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

import XCTest

@testable import GitHubTest

final class UsersRepositoryTests: XCTestCase {
    private var repository: UsersRepository!

    private let api = GitHubAPIMock()
    private let cache = CoreDataCacheMock()
    private let networkMonitor = NetworkMonitorMock()

    override func setUpWithError() throws {
        repository = UsersRepository(
            api: api,
            cache: cache,
            networkMonitor: networkMonitor
        )
        
        api.mockedData = [
            User(
                id: 11,
                name: "name1",
                avatarUrl: "avatarUrl1",
                followersUrl: "https://followers1.com",
                reposUrl: "https://repos1.com"
            ),
            User(
                id: 22,
                name: "name2",
                avatarUrl: "avatarUrl2",
                followersUrl: "https://followers2.com",
                reposUrl: "https://repos2.com"
            )
        ]
    }
    
    func test_Users_FromCache_Or_FromAPI_When_Network_Is_Reachable() async throws {
        networkMonitor.isReachable = true
        let preloadedFromCache = cache.loadObjects()
        let items = try await repository.fetchUsers()
        
        XCTAssertTrue(cache.isSaved)
        XCTAssertTrue(preloadedFromCache != cache.loadObjects() && items == cache.loadObjects())
    }
    
    func test_Users_FromCache_Or_FromAPI_When_Network_Is_Not_Reachable() async throws {
        networkMonitor.isReachable = false
        let preloadedFromCache = cache.loadObjects()
        let items = try await repository.fetchUsers()
        
        XCTAssertFalse(cache.isSaved)
        XCTAssertTrue(preloadedFromCache == cache.loadObjects() && items == preloadedFromCache)
    }
    
    func test_NetworkMonitor_IsStarted() async throws {
        XCTAssertTrue(networkMonitor.isStarted)
        repository = nil
        XCTAssertFalse(networkMonitor.isStarted)
    }
}
