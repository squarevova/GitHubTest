//
//  UsersRepository.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

final class UsersRepository: UsersRepositoryType {
    private let api: GitHubAPI
    
    init(api: GitHubAPI = GitHubAPIClient()) {
        self.api = api
    }
    
    func fetchUsers() async throws -> [User] {
        try await api.fetchUsers()
    }
}
