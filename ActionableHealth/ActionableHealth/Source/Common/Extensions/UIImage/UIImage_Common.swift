//
//  UIImage_CommonImage.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//



import UIKit
import ImageIO

//MARK:- Instance methods
extension UIImage{
    func resizeImage(newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {

        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        self.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
//MARK:- Additional methods
extension UIImage{

    class func getImageFromColor(color:UIColor?)-> UIImage{
        let frame:CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(frame.size)
        let  context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, (color?.CGColor)!)
        CGContextFillRect(context, frame)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    class func printAllImages(){
        let imageArray = NSBundle.mainBundle().pathsForResourcesOfType("png", inDirectory: nil)
        for image in imageArray {
            debugPrint(image)
        }
    }

    class func getLaunchImage() -> UIImage?{
        printAllImages()
        switch UIDevice.getDeviceType() {
        case .AppleIphone4, .AppleIphone4S:
            return UIImage(named: "Brand Assets-700@2x.png") // 640 960
        case .AppleIphone5, .AppleIphone5C, .AppleIphone5S:
            return UIImage(named: "Brand Assets-700-568h@2x.png") // 640 1136
        case .AppleIphone6, .AppleIphone6S, .AppleIphone7:
            return UIImage(named: "Brand Assets-800-667h@2x.png") // 750 1334
        case .AppleIphone6P, .AppleIphone6SP, .AppleIphone7P:
            return UIImage(named: "Brand Assets-800-Portrait-736h@3x.png") // 1242 2208
        default:
            return UIImage(named: "Brand Assets-700-568h@2x.png") // 640 960
        }
    }

    class func getBase64String(Image image:UIImage) -> String {
        let imageData:NSData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }

    class func getImageFromBase64String(Base64String strBase64:String) -> UIImage {
        let dataDecoded:NSData = NSData(base64EncodedString: strBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!
    }
}

//MARK:- Gif Methods
extension UIImage {

    public class func gifWithData(data: NSData) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            debugPrint("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func gifWithURL(gifUrl:String) -> UIImage? {
        // Validate URL
        guard let bundleURL:NSURL? = NSURL(string: gifUrl)
            else {
                debugPrint("SwiftGif: This image named \"\(gifUrl)\" does not exist")
                return nil
        }

        // Validate data
        guard let imageData = NSData(contentsOfURL: bundleURL!) else {
            debugPrint("SwiftGif: Cannot turn image named \"\(gifUrl)\" into NSData")
            return nil
        }

        return gifWithData(imageData)
    }

    public class func gifWithName(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = NSBundle.mainBundle()
            .URLForResource(name, withExtension: "gif") else {
                debugPrint("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }

        // Validate data
        guard let imageData = NSData(contentsOfURL: bundleURL) else {
            debugPrint("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifWithData(imageData)
    }

    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionaryRef = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                unsafeAddressOf(kCGImagePropertyGIFDictionary)),
            CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
            AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if a < b {
            let c = a
            a = b
            b = c
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImageRef]()
        var delays = [Int]()

        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(CGImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImageWithImages(frames,
                                                        duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
