import SwiftUI

@main
struct TestBatteryMonitorApp: App {

    private let diContainer: DIContainer

    init() {

        let networkService = NetworkServiceImpl()
        let monitorService = MonitoringServiceImpl()

        let services: DIServices.Services = DIServices.Services(
            networkService: networkService,
            monitoringService: monitorService
        )
        diContainer = DIContainerImpl(services: services)
    }

    var body: some Scene {
        WindowGroup {
            BatteryMonitorView(viewModel: BatteryMonitorViewModel(diContainer: diContainer))
        }
    }
}
