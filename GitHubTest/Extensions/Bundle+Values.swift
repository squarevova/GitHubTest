//
//  Bundle+Values.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 12/07/2024.
//

import Foundation

extension Bundle {
    var apiBaseUrl: URL {
        guard let urlStr = infoDictionary?["ApiBaseUrl"] as? String,
              let url = URL(string: urlStr) else {
            fatalError("Invalid base URL configuration for API!")
        }
        
        return url
    }
}
