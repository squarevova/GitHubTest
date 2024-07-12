//
//  UsersRepository.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import Foundation

final class UsersRepository: UsersRepositoryType {
    private let api: GitHubAPI
    private let cache: any CacheType<User>
    private let networkMonitor: NetworkMonitorType
    
    init(
        api: GitHubAPI = GitHubAPIClient(
            sessionClient: URLSessionClient(baseURL: Bundle.main.apiBaseUrl)
        ),
        cache: any CacheType<User> = CoreDataCache(),
        networkMonitor: NetworkMonitorType = NetworkMonitor()
    ) {
        self.api = api
        self.cache = cache
        self.networkMonitor = networkMonitor
        self.networkMonitor.start()
    }
    
    deinit {
        networkMonitor.stop()
    }
    
    func fetchUsers() async throws -> [User] {
        if networkMonitor.isReachable {
            let users = try await api.fetchUsers()
            cache.saveObjects(users)
            
            return users
        } else {
            return cache.loadObjects() ?? []
        }
    }
}
