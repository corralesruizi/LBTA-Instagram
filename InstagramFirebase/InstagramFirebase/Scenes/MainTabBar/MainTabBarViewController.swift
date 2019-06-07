import UIKit
import Firebase
import Photos

class MainTabBarController: UITabBarController {
    
    var tabVM: TabViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabMenu loaded")
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("TabMenu appearing")
        tabVM?.checkCredentials()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Presenting another controller")
    }
}

extension MainTabBarController : UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            
            PHPhotoLibrary.requestAuthorization { [weak self](authStatus) in
                switch authStatus {
                case .authorized:
                    DispatchQueue.main.async {
                        let navController = UINavigationController(rootViewController: AddPhotosViewController())
                        self?.present(navController, animated: true, completion: nil)
                    }
                default:
                    break
                }
            }
            
            return false
        }
        
        return true
    }
}
