import Foundation

protocol ValidatorConvertible {
    func validated(_ value: String?) throws -> Void
}

struct ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

enum ValidatorType {
    //case email
    //case password
    //case username
    //case projectIdentifier
    case requiredField
    //case age
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .requiredField: return RequiredFieldValidator()
        }
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    
    func validated(_ value: String?) throws ->Void {
        guard let text = value else { throw ValidationError("All fields are required") }
        
        guard !text.isEmpty else {
            throw ValidationError("All fields are required")
        }
    }
}
