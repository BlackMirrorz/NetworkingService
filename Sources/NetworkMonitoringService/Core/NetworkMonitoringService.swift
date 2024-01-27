//
//  NetworkMonitoringService.swift
//  NetworkMonitoringService
//
//  Created by Josh Robbins on 1/24/24.
//

import Combine
import Network
import OSLog

public final class NetworkMonitoringService: NSObject, ObservableObject {

  private let log = Logger(subsystem: "monitoring", category: "networkMonitoring")

  /// Network state is used to represent the current network connectivity status.
  public enum NetworkState {
    /// This state indicates that the network status has not been determined yet.
    case unknown
    /// This state represents an active network connection, whether it's Wi-Fi, cellular, or other types.
    case connected
    /// This state signifies that there is no active network connection.
    case notConnected
  }

  private var networkStatePublisher: AnyCancellable?
  private var pathMonitor: NetworkPathMonitorProtocol
  private var queue: DispatchQueue
  private var allowsDebugLogs: Bool = false

  @Published
  public var networkState: NetworkState = .unknown

  // MARK: - Initialization

  /// Creates an instance of the NetworkMonitoringService using the NetworkPathMonitorProtocol
  /// - Parameter pathMonitor: NetworkPathMonitorProtocol
  /// - Parameter allowsDebugLogs: Bool to allow console logging
  public init(pathMonitor: NetworkPathMonitorProtocol = NetworkPathService(), allowsDebugLogs: Bool = false) {
    self.pathMonitor = pathMonitor
    self.allowsDebugLogs = allowsDebugLogs
    let owner = String(describing: type(of: self))
    let queueLabel = "networkMonitoringQueue.\(owner)"
    queue = DispatchQueue(label: queueLabel)
    super.init()
    start()
  }

  // MARK: - LifeCycle

  deinit {
    cancel()
  }

  // MARK: - Callbacks

  /// Creates the NetworkMonitoringService and obsevres changes to Network States
  public func start() {

    pathMonitor.start()

    networkStatePublisher = pathMonitor.networkPathPublisher?
      .receive(on: DispatchQueue.main)
      .sink { [weak self] networkPath in

        guard let self = self else { return }

        switch networkPath.status {
        case .satisfied where self.networkState != .connected:
          self.networkState = .connected
          logMessage("Device is connected to a network")
        case .unsatisfied where self.networkState != .notConnected:
          self.networkState = .notConnected
          logMessage("Device is not connected to a network")
        default:
          break
        }
      }
  }

  /// Cancels theNetworkMonitoringService
  public func cancel() {
    pathMonitor.stop()
  }
}

// MARK: - Debugging

private extension NetworkMonitoringService {

  /// Logs the state of the Network Connectivity
  /// - Parameter message: message
  func logMessage(_ message: String) {
    guard allowsDebugLogs else { return }
    log.debug("\(message)")
  }
}
