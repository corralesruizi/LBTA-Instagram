import Foundation

public class Observable<ObservedType> {
    public typealias Observer = (_ observable: Observable<ObservedType>, ObservedType) -> Void
    
    private var observers: [Observer]
    
    public var value: ObservedType? {
        didSet {
            if let value = value {
                print("Value changed: \(value)")
                notifyObservers(value)
            }
        }
    }
    
    public init(_ value: ObservedType? = nil) {
        self.value = value
        observers = []
    }
    
    public func bind(observer: @escaping Observer) {
        print("Binded")
        self.observers.append(observer)
    }
    
    private func notifyObservers(_ value: ObservedType) {
        self.observers.forEach { [unowned self](observer) in
            observer(self, value)
        }
    }
}
