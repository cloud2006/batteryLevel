/// Dependency injection container
protocol DIContainer {
    /// Common app services
    var services: DIServices.Services { get }
}

enum DIServices {

    /// Common app services
    final class Services {

        let networkService: NetworkService

        let monitoringService: any MonitoringService

        init(networkService: NetworkService, monitoringService: any MonitoringService) {
            self.networkService = networkService
            self.monitoringService = monitoringService
        }
    }
}
