//
//  GitHubAPI.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

protocol GitHubAPI {
    func fetchUsers() async throws -> [User]
}
