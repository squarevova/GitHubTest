//
//  URLSessionClient.swift
//  OpenWeatherExample
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

import Foundation

final class URLSessionClient: URLSessionClientType {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, sessionConfiguration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        session = URLSession(configuration: sessionConfiguration)
    }
    
    func request(path: String, parameters: [String: String]? = nil) async throws -> Data {
        var url = baseURL.appendingPathComponent(path)
        
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if let parameters {
                components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
            }
            
            if let resultUrl = components.url {
                url = resultUrl
            } else {
                throw ApiError.badQueryURL
            }
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpUrlResponse = response as? HTTPURLResponse else {
            throw ApiError.badResponse
        }
        
        let statusCode = httpUrlResponse.statusCode
        
        if statusCode == 401 {
            throw ApiError.unauthorized
        }
        
        if 400..<500 ~= statusCode {
            throw ApiError.clientError(statusCode)
        }
        
        if statusCode >= 500 {
            throw ApiError.serverEror(statusCode)
        }
        
        return data
    }
}

extension URLSessionClient {
    enum ApiError: Error, Equatable {
        case badQueryURL
        case badResponse
        case unauthorized
        case clientError(Int)
        case serverEror(Int)
        case invalidJSON(String)
    }
}

extension URLSessionClient.ApiError {
    var description: String {
        switch self {
        case .badQueryURL:
            "Invalid query URL"
        case .badResponse:
            "Invalied response"
        case .unauthorized:
            "Unauthorized"
        case let .clientError(code):
            "Client error with code: \(code)"
        case .serverEror(let code):
            "Server error with code: \(code)"
        case .invalidJSON(let str):
            "Invalid JSON: \(str)"
        }
    }
}
