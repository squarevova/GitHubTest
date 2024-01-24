//
//  UsersRepositoryType.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

protocol UsersRepositoryType {
    func fetchUsers() async throws -> [User]
}
