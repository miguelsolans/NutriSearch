//
//  NetworkMonitor.swift
//  NutriSearch
//
//  Created by Miguel Solans on 05/03/2025.
//

import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    private(set) var isConnected: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        
        monitor.start(queue: queue)
    }
    
}
