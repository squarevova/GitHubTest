//
//  OpenWeatherAPIMock.swift
//  OpenWeatherExampleTests
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

import Foundation

@testable import GitHubTest

final class GitHubAPIMock: GitHubAPI {
    var mockedData = [User]()
    
    func fetchUsers() async throws -> [User] {
        mockedData
    }
}
