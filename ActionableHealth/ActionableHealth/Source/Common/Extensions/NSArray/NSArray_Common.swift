//
//  NSArray_Common.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 06/12/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

extension NSArray{

    func splitArrayWithSize(_ size:Int) -> NSArray {
        let totalCount = self.count
        var currentIndex = 0
        let splitArray = NSMutableArray()

        while currentIndex < totalCount {
            let range = NSMakeRange(currentIndex, min(size, totalCount-currentIndex))
            splitArray.add(self.subarray(with: range))
            currentIndex += size
        }

        return splitArray

    }
}
