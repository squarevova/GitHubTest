//
//  User.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

struct User {
    let id: Int
    let name: String
    let avatarUrl: String
}

extension User: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }
}
