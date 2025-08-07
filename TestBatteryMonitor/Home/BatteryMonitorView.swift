import SwiftUI
import Combine

struct BatteryMonitorView: View {
    @StateObject var viewModel: BatteryMonitorViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "battery.100")
                .imageScale(.large)
                .foregroundStyle(.green)
                .font(.system(size: 60))

            Text("Battery Level: \(viewModel.batteryLevel)%")
                .font(.title3)
                .bold()

            if viewModel.stateOfMonitoring {
                Button("Stop Monitoring") {
                    viewModel.stopMonitoring()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Start Monitoring") {
                    viewModel.startMonitoring()
                }
                .buttonStyle(.borderedProminent)
            }

            List {
                VStack(spacing: .zero) {
                    ForEach(viewModel.logMessages, id: \.self) { logrecord in
                        Text(logrecord)
                            .font(.body)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    BatteryMonitorView(viewModel: BatteryMonitorViewModel(diContainer: .preview))
}
