//
//  NetworkPathService.swift
//  NetworkMonitoringService
//
//  Created by Josh Robbins on 1/24/24.
//

import Combine
import Network

// Concrete implementation of NetworkPathMonitorProtocol using NWPathMonitor
public final class NetworkPathService: NetworkPathMonitorProtocol {

  public var networkPathPublisher: AnyPublisher<NetworkPath, Never>?
  private let subject = PassthroughSubject<NWPath, Never>()
  private let monitor = NWPathMonitor()

  // MARK: - Initialization

  public init() { }

  // MARK: - Callbacks

  public func start() {
    monitor.pathUpdateHandler = subject.send
    networkPathPublisher = subject
      .handleEvents(
        receiveSubscription: { _ in self.monitor.start(queue: .main) },
        receiveCancel: monitor.cancel
      )
      .map(NetworkPath.init(rawValue:))
      .eraseToAnyPublisher()
  }

  public func stop() {
    monitor.cancel()
  }
}
