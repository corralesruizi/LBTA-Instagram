import  UIKit

var imageCache = [String: UIImage]()

class InstagramImageView: UIImageView {
    
    var currentImage:UIImage?
    
    func loadImage(urlString: String){
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
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
            
            imageCache[url.absoluteString] = self?.currentImage
            
            
            DispatchQueue.main.async {
                self?.image = self?.currentImage
            }
            
            }.resume()
    }
}

