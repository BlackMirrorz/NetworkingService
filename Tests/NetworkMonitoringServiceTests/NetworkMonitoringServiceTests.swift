//
//  NetworkMonitoringServiceTests.swift
//  NetworkMonitoringServiceTests
//
//  Created by Josh Robbins on 1/24/24.
//

import Combine
import XCTest
@testable import NetworkMonitoringService

class NetworkMonitoringServiceTests: XCTestCase {

  private var cancellables: Set<AnyCancellable> = []

  // MARK: - Tests

  func testConnectedState() {
    let mockMonitor = MockNetworkPathMonitor()
    let service = NetworkMonitoringService(pathMonitor: mockMonitor)

    let expectation = self.expectation(description: "Network state should become connected")
    service.$networkState
      .dropFirst()
      .sink { state in
        if state == .connected {
          expectation.fulfill()
        }
      }
      .store(in: &cancellables)

    mockMonitor.send(networkPath: NetworkPath(status: .satisfied))
    waitForExpectations(timeout: 1)
  }

  func testNotConnectedState() {
    let mockMonitor = MockNetworkPathMonitor()
    let service = NetworkMonitoringService(pathMonitor: mockMonitor)

    let expectation = self.expectation(description: "Network state should become not connected")
    service.$networkState
      .dropFirst()
      .sink { state in
        if state == .notConnected {
          expectation.fulfill()
        }
      }
      .store(in: &cancellables)

    mockMonitor.send(networkPath: NetworkPath(status: .unsatisfied))
    waitForExpectations(timeout: 1)
  }

  func testNoStateChange() {
    let mockMonitor = MockNetworkPathMonitor()
    let service = NetworkMonitoringService(pathMonitor: mockMonitor)

    var stateChanges = 0
    service.$networkState
      .dropFirst()
      .sink { _ in
        stateChanges += 1
      }
      .store(in: &cancellables)

    mockMonitor.send(networkPath: NetworkPath(status: .requiresConnection))
    mockMonitor.send(networkPath: NetworkPath(status: .requiresConnection))

    XCTAssertEqual(stateChanges, 0, "There should be no state changes")
  }
}
