import  UIKit

class InstagramImageView: UIImageView {
    
    static let imageCache = NSCache<AnyObject, AnyObject>()
    var currentImage:UIImage?
    
    func loadImage(urlString: String){
        
        self.image=nil
        
        if let imageFromCache = InstagramImageView.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self](data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            guard let imageData = data else { return }
            self?.currentImage = UIImage(data: imageData)
            
            guard let currentImage = self?.currentImage else {return}
            InstagramImageView.imageCache.setObject(currentImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self?.image = self?.currentImage
            }
            
            }.resume()
    }
}

