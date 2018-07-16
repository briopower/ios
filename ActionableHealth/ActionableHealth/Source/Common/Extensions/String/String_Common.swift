//
//  String_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

//MARK:- Additional methods String
extension String{

    //MARK: Localized
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    //MARK: Height
    func getHeight(_ font:UIFont?, maxWidth:Double?) -> CGFloat {
        if font == nil || maxWidth == nil || self.isEmpty || self.characters.count == 0 {
            return CGSize.zero.height
        }else{
            return (self as NSString).boundingRect(with: CGSize(width: maxWidth!, height: DBL_MAX), options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSFontAttributeName : font!], context: nil).size.height
        }
    }

    //MARK: Lenght 
    func length() -> Int {
        return self.characters.count
    }

    //MARK: Numbers Only
    func getNumbers() -> String {
        let okayChars : Set<Character> = Set("1234567890".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
    
    //MARK: Validation
    func getValidObject() -> String? {
        let text = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if text == "" || text.isEmpty{
            return nil
        }
        return text
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.getValidObject())
    }

    //MARK:- Split
    func sliceFrom(_ start: String, to: String) -> String? {
        return (range(of: start)?.upperBound).flatMap { sInd in
            (range(of: to, range: sInd..<endIndex)?.lowerBound).map { eInd in
                substring(with: sInd..<eInd)
            }
        }
    }
}

//MARK:- Additional methods NSAttributedString
extension NSAttributedString{
    var localized: NSAttributedString {
        let mutAttrString = NSMutableAttributedString()

        self.enumerateAttributes(in: NSMakeRange(0, self.string.characters.count), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes:[String : AnyObject], range:NSRange, obj:UnsafeMutablePointer<ObjCBool>) in
            let temp = self.attributedSubstring(from: range)
            let attr = NSAttributedString(string: temp.string.localized, attributes: attributes)
            mutAttrString.append(attr)
        }

        return mutAttrString
    }
}
