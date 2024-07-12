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
                ForEach(usersViewModel.filteredUsers(filter: searchText), id: \.id) { user in
                    NavigationLink {
                        UserDetailsView(user: user)
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: user.avatarUrl)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    Image("Placeholder")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .frame(width: 64, height: 64)
                            
                            Text(user.name)
                        }
                    }
                }
            }
            .navigationTitle("users")
        }
        .searchable(text: $searchText)
        .task {
            await usersViewModel.fetchUsers()
        }
    }
}

#Preview {
    UsersListView()
}
