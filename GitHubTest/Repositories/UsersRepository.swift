//
//  UsersRepository.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

final class UsersRepository: UsersRepositoryType {
    private let api: GitHubAPI
    private let cache: any CacheType<User>
    private let networkMonitor = NetworkMonitor()
    
    init(
        api: GitHubAPI = GitHubAPIClient(),
        cache: any CacheType<User> = CoreDataCache()
    ) {
        self.api = api
        self.cache = cache
        
        networkMonitor.start()
    }
    
    deinit {
        networkMonitor.stop()
    }
    
    func fetchUsers() async throws -> [User] {
        return cache.fetchObjects()
        if networkMonitor.isReachable {
            let users = try await api.fetchUsers()
            cache.saveObjects(users)
            
            return users
        } else {
            return cache.fetchObjects()
        }
    }
}
