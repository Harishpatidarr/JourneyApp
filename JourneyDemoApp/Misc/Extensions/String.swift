//
//  String.swift
//

import Foundation

import UIKit

enum RegexType {
    case phone
    case adhar
    
    func getRegex() -> String {
        switch self {
        case .phone :
            return "[\\d]{10,10}" //mobile number validation
        case .adhar :
            return "^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$"
        }
    }
}

extension String {
    func isValid(type: RegexType) -> Bool {
        let regex = type.getRegex()
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    func encodedURL() -> (String) {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func trim() -> String {
        let value = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return value
    }
    
    func isValidAdhar() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
    func isValidVoterId() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^([a-zA-Z]){3}([0-9]){7}?$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidLicenseNo() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: """
                                             ^(([A-Z]{2}[0-9]{2})"
                                             "( )|([A-Z]{2}-[0-9]"
                                             "{2}))((19|20)[0-9]"
                                             "[0-9])[0-9]{7}$
""", options: .caseInsensitive)
        
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassportNo() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^(?!^0+$)[a-zA-Z0-9]{3,20}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
