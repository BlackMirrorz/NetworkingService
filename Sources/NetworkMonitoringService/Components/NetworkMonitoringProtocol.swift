//
//  NetworkMonitoringProtocol.swift
//  NetworkMonitoringService
//
//  Created by Josh Robbins on 1/24/24.
//

import Combine

// Protocol for abstracting network path monitoring
public protocol NetworkPathMonitorProtocol {
  var networkPathPublisher: AnyPublisher<NetworkPath, Never>? { get }
  func start()
  func stop()
}
