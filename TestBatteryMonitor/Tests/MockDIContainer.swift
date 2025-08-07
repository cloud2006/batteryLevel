final class MockDIContainer: DIContainer {

    let services: DIServices.Services

    init() {
        services = DIServices.Services(
            networkService: MockNetworkService(), monitoringService: MockMonitoringService()
        )
    }
}

extension DIContainer where Self == MockDIContainer {

    static var preview: DIContainer {
        return MockDIContainer()
    }
}
