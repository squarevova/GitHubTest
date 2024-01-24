//
//  UsersListView.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import SwiftUI

struct UsersListView: View {
    @StateObject private var usersViewModel = UsersListViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.id) { user in
                    Text(user.name)
                }
            }
            .navigationTitle("Users")
        }
        .searchable(text: $searchText)
        .task {
            await usersViewModel.fetchUsers()
        }
    }
    
    private var searchResults: [User] {
        if searchText.isEmpty {
            return usersViewModel.users
        } else {
            return usersViewModel.users.filter {
                $0.name.contains(
                    searchText
                        .lowercased()
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        }
    }
}

#Preview {
    UsersListView()
}