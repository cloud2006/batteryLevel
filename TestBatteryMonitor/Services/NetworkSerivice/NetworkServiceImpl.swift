import Foundation
import UIKit

final class NetworkServiceImpl: NetworkService {

    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid

    func sendData(level: Int, completion: @escaping () -> Void) {

        let data = encodedPayloadData(batteryLevel: level)

        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let taskID = UIApplication.shared.beginBackgroundTask(withName: "BatteryDataUpload") { [weak self] in
            if let taskID = self?.backgroundTaskID {
                UIApplication.shared.endBackgroundTask(taskID)
                self?.backgroundTaskID = .invalid
            }
        }
        backgroundTaskID = taskID

        URLSession.shared.dataTask(with: request) { [weak self] _, _, _ in
            DispatchQueue.main.async {
                completion()
            }
            if let self, self.backgroundTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                self.backgroundTaskID = .invalid
            }
        }.resume()
    }

    // Helper to create the JSON payload and encode it
    private func encodedPayloadData(batteryLevel: Int) -> Data? {
        let payload: [String: Any] = [
            "batteryLevel": batteryLevel,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []),
              let base64 = jsonData.base64EncodedString().data(using: .utf8) else {
            return nil
        }
        return base64
    }
}
