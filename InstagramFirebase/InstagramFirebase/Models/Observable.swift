import Foundation
class Observable<ObservedType>{
    typealias Listener = (ObservedType) -> Void
    var listener: Listener?
    
    var value:ObservedType
    {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: ObservedType) {
        self.value = value
    }
 
    func bind(listener: Listener?){
        self.listener = listener
        listener?(value)
    }
}
