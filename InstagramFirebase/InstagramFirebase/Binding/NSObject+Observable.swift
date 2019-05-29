import Foundation

extension NSObject {
    public func observe<T>(for observable: Observable<T>, with: @escaping (T) -> ()) {
        observable.bind { observable, value  in
            DispatchQueue.main.async {
                with(value)
            }
        }
    }
}
