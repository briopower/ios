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
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }

    //MARK: Height
    func getHeight(font:UIFont?, maxWidth:Double?) -> CGFloat {
        if font == nil || maxWidth == nil || self.isEmpty || self.characters.count == 0 {
            return CGSizeZero.height
        }else{
            return (self as NSString).boundingRectWithSize(CGSize(width: maxWidth!, height: DBL_MAX), options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName : font!], context: nil).size.height
        }
    }

    //MARK: Lenght 
    func length() -> Int {
        return self.characters.count
    }
    
    //MARK: Validation
    func getValidObject() -> String? {
        let text = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        if text == "" || text.isEmpty{
            return nil
        }
        return text
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.getValidObject())
    }
}

//MARK:- Additional methods NSAttributedString
extension NSAttributedString{
    var localized: NSAttributedString {
        let mutAttrString = NSMutableAttributedString()

        self.enumerateAttributesInRange(NSMakeRange(0, self.string.characters.count), options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired) { (attributes:[String : AnyObject], range:NSRange, obj:UnsafeMutablePointer<ObjCBool>) in
            let temp = self.attributedSubstringFromRange(range)
            let attr = NSAttributedString(string: temp.string.localized, attributes: attributes)
            mutAttrString.appendAttributedString(attr)
        }

        return mutAttrString
    }
}