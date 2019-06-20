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

extension UIImageView : Bindable {
    public typealias BindingType = UIImage
    
    public func observingValue() -> UIImage? {
        return self.image
    }
    
    public func updateValue(with value: UIImage) {
        self.image = value
    }
    
    public func bind(with observable: Observable<UIImage>) {
        self.register(for: observable)
        self.observe(for: observable) { [weak self] (value) in
            self?.updateValue(with: value)
        }
    }
}

extension UIButton : Bindable {
    public typealias BindingType = Bool
    
    public func observingValue() -> Bool? {
        return self.isEnabled
    }
    
    public func updateValue(with value: Bool) {
        self.isEnabled = value
    }
    
    public func bind(with observable: Observable<Bool>) {
        self.register(for: observable)
        self.observe(for: observable) { [weak self] (value) in
            self?.updateValue(with: value)
        }
    }
}
