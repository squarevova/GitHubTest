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
    let followersUrl: String
    let reposUrl: String
}

extension User: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
        case followersUrl = "followers_url"
        case reposUrl = "repos_url"
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
