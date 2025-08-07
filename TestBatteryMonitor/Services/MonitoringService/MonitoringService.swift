import Foundation

protocol MonitoringService: ObservableObject {

    var currentBatteryLevelPublisher: Published<Int>.Publisher { get }

    func startMonitoring()
    func stopMonitoring()
}
