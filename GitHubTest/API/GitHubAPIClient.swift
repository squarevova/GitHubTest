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

extension GitHubAPIClientError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .badResponse:
            "Invalied response"
        case .unauthorized:
            "Unauthorized"
        case let .clientError(code, data):
            "Client error with code: \(code), data: \(String(data: data, encoding: .utf8) ?? "")"
        case .serverEror(let code):
            "Server error with code: \(code)"
        }
    }
}

final class GitHubAPIClient: GitHubAPI {
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://api.github.com/users") else {
            throw GitHubAPIClientError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "accept")
        
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
