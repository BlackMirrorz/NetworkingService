//
//  NetworkPath.swift
//  NetworkMonitoringService
//
//  Created by Josh Robbins on 1/24/24.
//

import Network

/// Struct representing a network path with its status
public struct NetworkPath {
 
  var status: NWPath.Status

  init(status: NWPath.Status) {
    self.status = status
  }
}

// Extension to create a NetworkPath from an NWPath
public extension NetworkPath {

  init(rawValue: NWPath) {
    self.status = rawValue.status
  }
}
