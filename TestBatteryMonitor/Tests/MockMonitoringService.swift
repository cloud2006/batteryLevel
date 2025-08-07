import Combine

final class MockMonitoringService: MonitoringService {
    @Published private var currentBatteryLevel: Int = 0
    var currentBatteryLevelPublisher: Published<Int>.Publisher { $currentBatteryLevel }

    func startMonitoring() {
    }

    func stopMonitoring() {
    }

}
