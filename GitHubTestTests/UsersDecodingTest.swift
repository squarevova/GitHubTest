//
//  UsersDecodingTest.swift
//  GitHubTestTests
//
//  Created by Volodymyr Milichenko on 12/07/2024.
//

import XCTest
@testable import GitHubTest

final class UsersDecodingTest: XCTestCase {
    private var jsonData: Data!

    override func setUpWithError() throws {
        guard let fileURL = Bundle(for: type(of: self)).url(
            forResource: "UsersTestData", withExtension: "json"
        ) else {
            throw NSError(
                domain: "Test Forecast decoding",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "File not found"]
            )
        }
        
        jsonData = try Data(contentsOf: fileURL)
    }

    func testUsersDecodingFromJSON() throws {
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: jsonData)

        XCTAssertEqual(users.count, 2)

        let firstItem = users.first
        XCTAssertNotNil(firstItem)
        XCTAssertEqual(firstItem!.id, 1)
        XCTAssertEqual(firstItem!.name, "mojombo")
        XCTAssertEqual(firstItem!.avatarUrl, "https://avatars.githubusercontent.com/u/1?v=4")
        XCTAssertEqual(firstItem!.followersUrl, "https://api.github.com/users/mojombo/followers")
        XCTAssertEqual(firstItem!.reposUrl, "https://api.github.com/users/mojombo/repos")
        
        let secondItem = users.last
        XCTAssertNotNil(secondItem)
        XCTAssertEqual(secondItem!.id, 2)
        XCTAssertEqual(secondItem!.name, "defunkt")
        XCTAssertEqual(secondItem!.avatarUrl, "https://avatars.githubusercontent.com/u/2?v=4")
        XCTAssertEqual(secondItem!.followersUrl, "https://api.github.com/users/defunkt/followers")
        XCTAssertEqual(secondItem!.reposUrl, "https://api.github.com/users/defunkt/repos")
    }
}
