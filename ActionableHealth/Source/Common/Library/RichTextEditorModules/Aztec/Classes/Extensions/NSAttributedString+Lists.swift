import Foundation
import UIKit


// MARK: - NSAttributedString Lists Helpers
//
extension NSAttributedString {
    
    /// Internal convenience helper. Returns the internal string as a NSString instance
    ///
    var foundationString: NSString {
        return string as NSString
    }

    /// Returns the range of the given text list that contains the given location.
    ///
    /// - Parameter list: The textList to search for.
    /// - Parameter location: The location in the text list.
    ///
    /// - Returns: An NSRange optional containing the range of the list or nil if no list was found.
    ///
    func range(of list: TextList, at location: Int) -> NSRange? {

        var effectiveRange = NSRange()
        let targetRange = rangeOfEntireString
        guard
            let paragraphStyle = attribute(.paragraphStyle, at: location, longestEffectiveRange: &effectiveRange, in: targetRange) as? ParagraphStyle,
            let foundList = paragraphStyle.lists.last,
            foundList == list
        else {
            return nil
        }
        let listDepth = paragraphStyle.lists.count

        var resultRange = effectiveRange
        //Note: The effective range will only return the range of the in location NSParagraphStyleAttributed 
        // but this can be different on preceding or suceeding range but is the same TextList, 
        // so we need to expand the range to grab all the TextList coverage.
        while resultRange.location > 0 {
            guard
                let paragraphStyle = attribute(.paragraphStyle, at: resultRange.location-1, longestEffectiveRange: &effectiveRange, in: targetRange) as? ParagraphStyle,
                let foundList = paragraphStyle.lists.last
            else {
                    break;
            }
            if ((listDepth == paragraphStyle.lists.count && foundList == list) ||
                listDepth < paragraphStyle.lists.count) {
               resultRange = resultRange.union(withRange: effectiveRange)
            } else {
                break;
            }
        }
        while resultRange.endLocation < self.length {
            guard
                let paragraphStyle = attribute(.paragraphStyle, at: resultRange.endLocation, longestEffectiveRange: &effectiveRange, in: targetRange) as? ParagraphStyle,
                let foundList = paragraphStyle.lists.last
            else {
                break;
            }
            if ((listDepth == paragraphStyle.lists.count && foundList == list) ||
                listDepth < paragraphStyle.lists.count) {
                resultRange = resultRange.union(withRange: effectiveRange)
            } else {
                break;
            }
        }

        return resultRange
    }

    /// Returns the index of the item at the given location within the list.
    ///
    /// - Parameters:
    ///   - list: The list.
    ///   - location: The location of the item.
    ///
    /// - Returns: Returns the index within the list.
    ///
    func itemNumber(in list: TextList, at location: Int) -> Int {
        guard
            let paragraphStyle = attribute(.paragraphStyle, at: location, effectiveRange: nil) as? ParagraphStyle
            else {
                return NSNotFound
        }
        let listDepth = paragraphStyle.lists.count
        guard let rangeOfList = range(of:list, at: location) else {
            return NSNotFound
        }
        var numberInList = 1
        let paragraphRanges = self.paragraphRanges(spanning: rangeOfList)

        for (_, enclosingRange) in paragraphRanges {
            if NSLocationInRange(location, enclosingRange) {
                return numberInList
            }
            if let paragraphStyle = attribute(.paragraphStyle, at: enclosingRange.location, effectiveRange: nil) as? ParagraphStyle,
               listDepth == paragraphStyle.lists.count {
                numberInList += 1
            }
        }
        return NSNotFound
    }

    /// Returns a NSRange instance that covers the entire string (Location = 0, Length = Full)
    ///
    var rangeOfEntireString: NSRange {
        return NSRange(location: 0, length: length)
    }

    /// Returns the TextList attribute at the specified NSRange, if any.
    ///
    /// - Parameter index: The index at which to inspect.
    ///
    /// - Returns: A TextList optional.
    ///
    func textListAttribute(atIndex index: Int) -> TextList? {
        return (attribute(.paragraphStyle, at: index, effectiveRange: nil) as? ParagraphStyle)?.lists.last
    }

    /// Returns the TextList attribute, assuming that there is one, spanning the specified Range.
    ///
    /// - Parameter range: Range to check for TextLists
    ///
    /// - Returns: A TextList optional.
    ///
    func textListAttribute(spanning range: NSRange) -> TextList? {
        // NOTE:
        // We're using this mechanism, instead of the old fashioned 'attribute:atIndex:effectiveRange:' because
        // whenever the "next substring" has a different set of attributes, the effective range gets cut, even though
        // the attribute is present in the neighbor!
        //
        var list: TextList?

        enumerateAttribute(.paragraphStyle, in: range, options: []) { (attribute, range, stop) in
            if let paragraphStyle = attribute as? ParagraphStyle {
                list = paragraphStyle.lists.last
            }
            stop.pointee = true
        }

        return list
    }

    /// Finds the paragraph ranges in the specified string intersecting the specified range.
    ///
    /// - Parameters range: The range within the specified string to find paragraphs.
    ///
    /// - Returns: An array containing an NSRange for each paragraph intersected by the specified range.
    ///
    func paragraphRanges(spanning range: NSRange, includeParagraphSeparator: Bool = true) -> [NSRange] {
        var paragraphRanges = [NSRange]()
        let swiftRange = string.range(fromUTF16NSRange: range)

        string.enumerateSubstrings(in: swiftRange, options: .byParagraphs) { [unowned self] (substring, substringRange, enclosingRange, stop) in
            let paragraphRange = includeParagraphSeparator ? enclosingRange : substringRange
            paragraphRanges.append(self.string.utf16NSRange(from: paragraphRange))
        }

        return paragraphRanges
    }

    /// Finds the paragraph ranges in the specified string intersecting the specified range.
    ///
    /// - Parameters range: The range within the specified string to find paragraphs.
    ///
    /// - Returns: An array containing an NSRange for each paragraph intersected by the specified range.
    ///
    func paragraphRanges(spanning range: NSRange) -> ([(NSRange, NSRange)]) {
        var paragraphRanges = [(NSRange, NSRange)]()
        let swiftRange = string.range(fromUTF16NSRange: range)

        string.enumerateSubstrings(in: swiftRange, options: .byParagraphs) { [unowned self] (substring, substringRange, enclosingRange, stop) in
            let substringNSRange = self.string.utf16NSRange(from: substringRange)
            let enclosingNSRange = self.string.utf16NSRange(from: enclosingRange)

            paragraphRanges.append((substringNSRange, enclosingNSRange))
        }

        return paragraphRanges
    }

    /// Returns the range of characters representing the paragraph or paragraphs containing a given range.
    ///
    /// This is an attributed string wrapper for `NSString.paragraphRangeForRange()`
    ///
    func paragraphRange(for range: NSRange) -> NSRange {
        let swiftRange = string.range(fromUTF16NSRange: range)
        let outRange = string.paragraphRange(for: swiftRange)

        return string.utf16NSRange(from: outRange)
    }
    
    func paragraphRange1(for attachment: NSTextAttachment) -> NSRange {
        // We assume the attachment IS in the string.  This method should not be called otherwise.
        let attachmentRange = ranges(forAttachment: attachment).first!
        
        return paragraphRange(for: attachmentRange)
    }

    // MARK: - Paragraph Ranges: Before and After

    func paragraphRange(after paragraphRange: NSRange) -> NSRange? {
        guard paragraphRange.upperBound < length,
            let newUpperBound = string.location(after: paragraphRange.upperBound) else {
                return nil
        }
        
        let rangeLength = newUpperBound - paragraphRange.upperBound
        let range = NSRange(location: paragraphRange.upperBound, length: rangeLength)
        
        return self.paragraphRange(for: range)
    }
    
    func paragraphRange(before paragraphRange: NSRange) -> NSRange? {
        guard paragraphRange.lowerBound > 0,
            let newLowerBound = string.location(before: paragraphRange.lowerBound) else {
                return nil
        }
        
        let rangeLength = paragraphRange.lowerBound - newLowerBound
        let range = NSRange(location: newLowerBound, length: rangeLength)
        
        return self.paragraphRange(for: range)
    }
    
    
    func paragraphRange(around range: NSRange, where match: ([ParagraphProperty]) -> Bool) -> NSRange? {
        let paragraphRange = self.paragraphRange(for: range)
        
        guard let paragraphStyle = self.attribute(.paragraphStyle, at: paragraphRange.lowerBound, effectiveRange: nil) as? ParagraphStyle,
            match(paragraphStyle.properties) else {
                return nil
        }

        var finalRange = paragraphRange
        
        enumerateParagraphRanges(before: paragraphRange) { (paragraphRange) -> Bool in
            guard let paragraphStyle = self.attribute(.paragraphStyle, at: paragraphRange.lowerBound, effectiveRange: nil) as? ParagraphStyle,
                match(paragraphStyle.properties) else {
                    return false
            }
            
            finalRange = NSRange(location: paragraphRange.lowerBound, length: finalRange.length + paragraphRange.length)
            return true
        }
        
        enumerateParagraphRanges(after: paragraphRange) { (paragraphRange) -> Bool in
            guard let paragraphStyle = self.attribute(.paragraphStyle, at: paragraphRange.lowerBound, effectiveRange: nil) as? ParagraphStyle,
                match(paragraphStyle.properties) else {
                    return false
            }
            
            finalRange = NSRange(location: finalRange.lowerBound, length: finalRange.length + paragraphRange.length)
            return true
        }
        
        return finalRange
    }
    
    // MARK: - Paragraph Ranges: Enumeration
    
    /// Enumerates the paragraph ranges after the specified paragraph range.
    ///
    /// - Parameters:
    ///     - paragraphRange: the reference paragraph range.
    ///     - step: closure executed for each paragraph range found after the reference one.  The return
    ///         value of this closure indicates if paragraph enumeration should continue (true is yes).
    ///
    func enumerateParagraphRanges(after paragraphRange: NSRange, using step: (NSRange) -> Bool) {
        var currentParagraphRange = paragraphRange
        
        while let followingParagraphRange = self.paragraphRange(after: currentParagraphRange) {
            guard step(followingParagraphRange) else {
                break
            }
            
            currentParagraphRange = followingParagraphRange
        }
    }
    
    /// Enumerates the paragraph ranges before the specified paragraph range.
    ///
    /// - Parameters:
    ///     - paragraphRange: the reference paragraph range.
    ///     - step: closure executed for each paragraph range found before the reference one.  The return
    ///         value of this closure indicates if paragraph enumeration should continue (true is yes).
    ///
    func enumerateParagraphRanges(before paragraphRange: NSRange, using step: (NSRange) -> Bool) {
        var currentParagraphRange = paragraphRange
        
        while let previousParagraphRange = self.paragraphRange(before: currentParagraphRange) {
            guard step(previousParagraphRange) else {
                break
            }
            
            currentParagraphRange = previousParagraphRange
        }
    }


    /// Enumerates all of the paragraphs spanning a NSRange
    ///
    /// - Parameters:
    ///     - range: Range that should be checked for paragraphs
    ///     - reverseOrder: Boolean indicating if the paragraphs should be enumerated in reverse order
    ///     - block: Closure to be executed for each paragraph
    ///
    func enumerateParagraphRanges(spanning range: NSRange, reverseOrder: Bool = false, using block: ((NSRange, NSRange) -> Void)) {
        var ranges = paragraphRanges(spanning: range)
        if reverseOrder {
            ranges.reverse()
        }

        for (range, enclosingRange) in ranges {
            block(range, enclosingRange)
        }
    }
}
