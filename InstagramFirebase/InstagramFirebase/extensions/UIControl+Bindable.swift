import Foundation
import  UIKit


extension UITextField : Bindable {
    public typealias BindingType = String
    
    public func observingValue() -> String? {
        return self.text
    }
    
    public func updateValue(with value: String) {
        self.text = value
    }
    
    public func bind(with observable: Observable<String>) {
        self.register(for: observable)
        self.observe(for: observable) { [weak self] (value) in
            self?.updateValue(with: value)
        }
    }    
}





