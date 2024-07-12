//
//  NetworkMonitorMock.swift
//  OpenWeatherExampleTests
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

@testable import GitHubTest

final class NetworkMonitorMock: NetworkMonitorType {
    var isStarted = false
    
    var isReachable: Bool = false
    
    func start() {
        isStarted = true
    }
    
    func stop() {
        isStarted = false
    }
}
