//
//  GitHubAPITests.swift
//  GitHubTestTests
//
//  Created by Volodymyr Milichenko on 12/07/2024.
//

import XCTest
@testable import GitHubTest

final class GitHubAPITests: XCTestCase {
    private var client = GitHubAPIClient(
        sessionClient: URLSessionClient(
            baseURL: Bundle.main.apiBaseUrl,
            sessionConfiguration: .ephemeral
        )
    )

    func testGetUsers() async throws {
        do {
            let items = try await client.fetchUsers()
            XCTAssertFalse(items.isEmpty)
        } catch {
            XCTFail()
        }
    }

    func testBadQuery() async throws {
        client = GitHubAPIClient(sessionClient: URLSessionClientMockBadQuery())
        
        do {
            _ = try await client.fetchUsers()
        } catch {
            XCTAssertTrue(error is URLSessionClient.ApiError)
            XCTAssertEqual(error as? URLSessionClient.ApiError, URLSessionClient.ApiError.badQueryURL)
        }
    }
    
    func testBadResponse() async throws {
        client = GitHubAPIClient(sessionClient: URLSessionClientMockBadResponse())
        
        do {
            _ = try await client.fetchUsers()
        } catch {
            XCTAssertTrue(error is URLSessionClient.ApiError)
            XCTAssertEqual(error as? URLSessionClient.ApiError, URLSessionClient.ApiError.badResponse)
        }
    }

    func testClientError() async throws {
        let statusCode = 404
        
        client = GitHubAPIClient(sessionClient: URLSessionClientMockBadStatusCode(statusCode))
        
        do {
            _ = try await client.fetchUsers()
        } catch {
            XCTAssertTrue(error is URLSessionClient.ApiError)
            XCTAssertEqual(error as? URLSessionClient.ApiError, URLSessionClient.ApiError.clientError(statusCode))
        }
    }
    
    func testServerError() async throws {
        let statusCode = 500
        
        client = GitHubAPIClient(sessionClient: URLSessionClientMockBadStatusCode(statusCode))
        
        do {
            _ = try await client.fetchUsers()
        } catch {
            XCTAssertTrue(error is URLSessionClient.ApiError)
            XCTAssertEqual(error as? URLSessionClient.ApiError, URLSessionClient.ApiError.serverEror(statusCode))
        }
    }
    
    func testInvalidJSON() async throws {
        client = GitHubAPIClient(sessionClient: URLSessionClientMockEmptyData())
        
        do {
            _ = try await client.fetchUsers()
        } catch {
            XCTAssertTrue(error is URLSessionClient.ApiError)
            XCTAssertEqual(error as? URLSessionClient.ApiError, URLSessionClient.ApiError.invalidJSON(""))
        }
    }
}
