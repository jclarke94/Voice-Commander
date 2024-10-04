//
//  NetworkReachability.swift
//  Alice
//
//  Created by James Wolfe on 10/02/2023.
//

import Network

protocol NetworkReachabilityObserver: AnyObject {
    func statusDidChange(status: NWPath.Status)
}

class NetworkReachability {

    private struct NetworkChangeObservation {
        weak var observer: NetworkReachabilityObserver?
    }

    private var monitor = NWPathMonitor()
    private var observations = [ObjectIdentifier: NetworkChangeObservation]()
    /// Test mode, used to artificially prevent the app from accessing the internet
    var testMode: TestMode = .reachable
    
    /// Last recorded value of the devices' network connectivity status
    var currentStatus: NWPath.Status {
        guard testMode == .reachable else { return .unsatisfied }
        return monitor.currentPath.status
    }

    static let shared = NetworkReachability()

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            for (id, observations) in self.observations {

                // If any observer is nil, remove it from the list of observers
                guard let observer = observations.observer else {
                    self.observations.removeValue(forKey: id)
                    continue
                }

                DispatchQueue.main.async(execute: {
                    observer.statusDidChange(status: path.status)
                })
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    /// Adds an observer to the device's network status,
    /// runs code dependent on the value that this changes to
    /// - Parameter observer: Observer object containing a
    /// function that runs on network reachability status change
    func addObserver(observer: NetworkReachabilityObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = NetworkChangeObservation(observer: observer)
    }
    
    /// Removes an observer of the device's network status
    /// - Parameter observer: Observer object containing a
    /// function that runs on network reachability status change
    func removeObserver(observer: NetworkReachabilityObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

}

extension NetworkReachability {

    enum TestMode {

        // MARK: - Cases
        case reachable
        case networkUnreachable

    }

}
