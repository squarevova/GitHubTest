//
//  GitHubAPIClientError.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import Foundation

final class GitHubAPIClient: GitHubAPI {
    private let sessionClient: URLSessionClientType
    
    // MARK: - Init
    
    init(sessionClient: URLSessionClientType) {
        self.sessionClient = sessionClient
    }
}

extension GitHubAPIClient {
    func fetchUsers() async throws -> [User] {
        let data = try await sessionClient.request(path: "users")
        
        do {
            let response = try JSONDecoder().decode([User].self, from: data)
            return response
        } catch {
            throw URLSessionClient.ApiError.invalidJSON(String(data: data, encoding: .utf8) ?? "")
        }
    }
}
