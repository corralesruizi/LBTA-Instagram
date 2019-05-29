import  UIKit
import Foundation
class InstagramButtom: UIButton {
    override var isEnabled: Bool{
        didSet{
            backgroundColor = isEnabled ? UIColor.mainAppColor : UIColor.lightMainAppColor
        }
    }
}
