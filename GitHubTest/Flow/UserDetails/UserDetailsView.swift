//
//  UserDetailsView.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import SwiftUI

struct UserDetailsView: View {
    let user: User
    
    var body: some View {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(user.name)
    }
}

#Preview {
    UserDetailsView(
        user: User(
            id: 1,
            name: "Test",
            avatarUrl: "",
            followersUrl: "",
            reposUrl: ""
        )
    )
}
