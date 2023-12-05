//
//  Range+Utility.swift
//  
//
//  Created by Will McGinty on 12/5/23.
//

import Foundation

public extension Range where Bound: Comparable {

    func intersection(with other: Range<Bound>) -> Range<Bound>? {
        let start = Swift.max(lowerBound, other.lowerBound)
        let end = Swift.min(upperBound, other.upperBound)

        return start < end ? start..<end : nil
    }

    func contains(_ other: Range<Bound>) -> Bool {
        return lowerBound <= other.lowerBound && upperBound >= other.upperBound
    }

    func subtracting(other range: Range) -> [Range] {
        guard overlaps(range) else { return [self] }

        var results = [Range]()
        if lowerBound < range.lowerBound {
            results.append(lowerBound..<range.lowerBound)

            if upperBound > range.upperBound {
                results.append(range.upperBound..<upperBound)
            }

        } else if upperBound > range.upperBound {
            results.append(range.upperBound..<upperBound)

            if lowerBound < range.lowerBound {
                results.append(lowerBound..<range.lowerBound)
            }
        }

        return results
    }
}
