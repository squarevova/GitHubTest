//
//  GitHubAPIClientError.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import Foundation

enum GitHubAPIClientError: Error {
    case invalidURL
    case badResponse
    case unauthorized
    case clientError(Int, Data)
    case serverEror(Int)
}

final class GitHubAPIClient: GitHubAPI {
    private let accessToken = "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"

    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://api.github.com/users") else {
            throw GitHubAPIClientError.invalidURL
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession(configuration: .default).data(for: request)
        
        guard let httpUrlResponse = response as? HTTPURLResponse else {
            throw GitHubAPIClientError.badResponse
        }
        
        let statusCode = httpUrlResponse.statusCode

        if statusCode == 401 {
            throw GitHubAPIClientError.unauthorized
        }

        if 400..<500 ~= statusCode {
            throw GitHubAPIClientError.clientError(statusCode, data)
        }

        if statusCode >= 500 {
            throw GitHubAPIClientError.serverEror(statusCode)
        }
        
        return try JSONDecoder().decode([User].self, from: data)
    }
}
