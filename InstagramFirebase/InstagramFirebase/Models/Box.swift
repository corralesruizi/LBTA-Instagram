import Foundation
class Box<T> {
    
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    var value: T {
        didSet{
            listener?(value)
            print("Box.didSet")
        }
    }
    
    init(_ value: T) {
        self.value = value
        print("Box.Init")
    }
    
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value)
        print("Box.Bind")
    }
}
