import  UIKit

class InstagramImageView: UIImageView {
    
    func loadImage(urlString: String){
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self](data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self?.image = photoImage
            }
            
            }.resume()
    }
}

