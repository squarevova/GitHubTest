//
//  GitHubTestApp.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        if ProcessInfo.processInfo.environment["isTesting"] == "true" {
            TestApp.main()
        } else {
            GitHubTestApp.main()
        }
    }
}

struct GitHubTestApp: App {
    var body: some Scene {
        WindowGroup {
            UsersListView()
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {}
    }
}
