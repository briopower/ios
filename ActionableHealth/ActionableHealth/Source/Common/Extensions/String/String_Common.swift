//
//  String_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import UIKit

//MARK:- Additional methods

extension String{
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func getHeight(font:UIFont?, maxWidth:Double?) -> CGFloat {
        if font == nil || maxWidth == nil || self.isEmpty || self.characters.count == 0 {
            return CGSizeZero.height
        }else{
            return (self as NSString).boundingRectWithSize(CGSize(width: maxWidth!, height: DBL_MAX), options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName : font!], context: nil).size.height
        }
    }

    func getValidObject() -> String? {
        
        if self == "" || self.isEmpty{
            return nil
        }

        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

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