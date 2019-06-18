import UIKit
import Firebase
import Photos

class MainTabBarController: UITabBarController {
    
    var tabVM: TabViewModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tab didLoad")
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Tab wilAppear")
        tabVM?.checkCredentials()
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
