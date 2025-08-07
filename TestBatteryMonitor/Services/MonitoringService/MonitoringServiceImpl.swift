import Foundation
import UIKit

final class MonitoringServiceImpl: MonitoringService {
    var currentBatteryLevelPublisher: Published<Int>.Publisher { $currentBatteryLevel }
    @Published private(set) var currentBatteryLevel: Int = 0

    private var timer: Timer?
    private var interval: Double = 120

    init(timer: Timer? = nil) {
        self.timer = timer
    }

    // Called when monitoring starts. Enables battery monitoring and kicks off periodic updates.
    func startMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        updateBatteryLevel()    // Capture initial battery level
        scheduleTimer()         // Schedule periodic updates
    }

    // Stops battery monitoring and clears timer
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        UIDevice.current.isBatteryMonitoringEnabled = false
    }

    // Schedules a timer that fires every 60 seconds to collect battery info and send it
    private func scheduleTimer() {
        timer?.invalidate() // Clear any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.updateBatteryLevel()
        }
    }

    // Retrieves the current battery level and logs it
    private func updateBatteryLevel() {
        currentBatteryLevel = Int(UIDevice.current.batteryLevel * 100)
    }
}
