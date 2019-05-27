import Foundation

struct Comment {
    
    let user: firebaseUser
    let text: String
    let uid: String
    let creationDate: Date
    
    init(user: firebaseUser, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
