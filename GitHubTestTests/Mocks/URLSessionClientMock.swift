//
//  URLSessionClientMock.swift
//  OpenWeatherExampleTests
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

import Foundation

@testable import GitHubTest

final class URLSessionClientMockEmptyData: URLSessionClientType {
    func request(path: String, parameters: [String : String]?) async throws -> Data {
        return Data()
    }
}

final class URLSessionClientMockBadQuery: URLSessionClientType {
    func request(path: String, parameters: [String : String]?) async throws -> Data {
        throw URLSessionClient.ApiError.badQueryURL
    }
}

final class URLSessionClientMockBadResponse: URLSessionClientType {
    func request(path: String, parameters: [String : String]?) async throws -> Data {
        throw URLSessionClient.ApiError.badResponse
    }
}

final class URLSessionClientMockBadStatusCode: URLSessionClientType {
    let statusCode: Int
    
    init(_ statusCode: Int) {
        self.statusCode = statusCode
    }
    
    func request(path: String, parameters: [String : String]?) async throws -> Data {
        if 402..<500 ~= statusCode {
            throw URLSessionClient.ApiError.clientError(statusCode)
        }
        
        if statusCode >= 500 {
            throw URLSessionClient.ApiError.serverEror(statusCode)
        }
        
        return Data()
    }
}

