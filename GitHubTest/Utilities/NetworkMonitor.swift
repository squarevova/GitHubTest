//
//  NetworkMonitor.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

import Network

final class NetworkMonitor: NetworkMonitorType {
    private let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection

    var isReachable: Bool {
        status == .satisfied
    }
    
    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }

        let queue = DispatchQueue(label: "com.test.github")
        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
    }
}
