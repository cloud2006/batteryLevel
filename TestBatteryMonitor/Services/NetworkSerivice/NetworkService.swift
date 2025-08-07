import Foundation

protocol NetworkService {

    func sendData(level: Int, completion: @escaping () -> Void)
}
