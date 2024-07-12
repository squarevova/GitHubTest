//
//  NetworkMonitorType.swift
//  OpenWeatherExample
//
//  Created by Volodymyr Milichenko on 29/01/2024.
//

protocol NetworkMonitorType {
    var isReachable: Bool { get }
    
    func start()
    func stop()
}

