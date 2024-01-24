//
//  UsersListView.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import SwiftUI

struct UsersListView: View {
    @StateObject private var usersViewModel = UsersListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(usersViewModel.users, id: \.id) { user in
                    Text(user.name)
                }
            }
        }
        .task {
            await usersViewModel.fetchUsers()
        }
        .navigationTitle("Users")
    }
}

#Preview {
    UsersListView()
}
