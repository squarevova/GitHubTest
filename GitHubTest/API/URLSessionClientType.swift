//
//  URLSessionClientType.swift
//  OpenWeatherExample
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

import Foundation

protocol URLSessionClientType {
    func request(path: String, parameters: [String: String]?) async throws -> Data
}

extension URLSessionClientType {
    func request(path: String, parameters: [String: String]? = nil) async throws -> Data {
        try await request(path: path, parameters: parameters)
    }
}
