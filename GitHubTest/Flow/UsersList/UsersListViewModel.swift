//
//  UsersListViewModel.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import Combine
import SwiftUI

@MainActor
final class UsersListViewModel: ObservableObject {
    @Published var users = [User]()
    
    private let usersRepository: UsersRepositoryType
    
    init(usersRepository: UsersRepositoryType = UsersRepository()) {
        self.usersRepository = usersRepository
    }
    
    func fetchUsers() async {
        do {
            users = try await usersRepository.fetchUsers()
        } catch {
            assertionFailure("Error while fetching users: \(error)")
        }
    }
    
    func filteredUsers(filter: String = "") -> [User] {
        if filter.isEmpty {
            return users
        } else {
            return users.filter {
                $0.name.contains(
                    filter
                        .lowercased()
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        }
    }
}
