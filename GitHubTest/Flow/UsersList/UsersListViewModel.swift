//
//  UsersListViewModel.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import Combine

@MainActor
final class UsersListViewModel: ObservableObject {
    @Published var users = [User]()
    
//    private let usersRepository: UsersRepositoryType
//    
//    init(usersRepository: UsersRepositoryType) {
//        self.usersRepository = usersRepository
//    }
    
    private let usersAPI = GitHubAPIClient()
    
    func fetchUsers() async {
        do {
            users = try await usersAPI.fetchUsers()
        } catch {
            assertionFailure("Error while fetching users")
        }
    }
}
