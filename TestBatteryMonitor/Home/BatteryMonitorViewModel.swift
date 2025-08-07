import Foundation
import UIKit
import Combine

// ViewModel responsible for monitoring the device's battery level and sending data periodically.
class BatteryMonitorViewModel: ObservableObject {

    // Public properties observed by the UI
    @Published var batteryLevel: Int = 0
    @Published var logMessages: [String] = []
    @Published var stateOfMonitoring: Bool = false

    // Internal state
    private let diContainer: DIContainer
    private var lastSentTime: Date?
    private var cancellables = Set<AnyCancellable>()

    // Computed property that formats the last send time for display
    var lastSentTimeFormatted: String {
        guard let date = lastSentTime else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }

    init(diContainer: DIContainer) {
        self.diContainer = diContainer

        diContainer.services.monitoringService
            .currentBatteryLevelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] level in
                self?.batteryLevel = level

                diContainer.services.networkService.sendData(level: level) {
                    if level != 0 {
                        let timestamp = self?.currentShortTimeString() ?? ""
                        let logEntry = "Battery level updated: \(level)% at \(timestamp)"
                        self?.logMessages.append(logEntry)
                    }
                }
            }
            .store(in: &cancellables)
    }

    // Start battery monitoring
    func startMonitoring() {
        diContainer.services.monitoringService.startMonitoring()
    }

    // Stops battery monitoring and clears timer. Logs the stop event.
    func stopMonitoring() {
        diContainer.services.monitoringService.stopMonitoring()
    }

    // Helper to get the current time formatted as HH:mm (e.g., "14:30")
    private func currentShortTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }

    private func sendData() {
        diContainer.services.networkService.sendData(level: batteryLevel) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.lastSentTime = Date()
                let logEntry = "Data sent at \(self.lastSentTimeFormatted)"
                self.logMessages.append(logEntry)
            }
        }
    }
}
