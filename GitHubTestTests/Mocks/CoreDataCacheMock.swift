//
//  CoreDataCacheMock.swift
//  OpenWeatherExampleTests
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

import Foundation

@testable import GitHubTest

final class CoreDataCacheMock: CacheType {
    var isSaved = false
    
    private var objects = [
        User(
            id: 1,
            name: "name1",
            avatarUrl: "avatarUrl1",
            followersUrl: "https://followers1.com",
            reposUrl: "https://repos1.com"
        ),
        User(
            id: 2,
            name: "name2",
            avatarUrl: "avatarUrl2",
            followersUrl: "https://followers2.com",
            reposUrl: "https://repos2.com"
        )
    ]

    func loadObjects() -> [User]? {
        objects
    }
    
    func saveObjects(_ objects: [User]) {
        self.objects = objects
        isSaved = true
    }
}
