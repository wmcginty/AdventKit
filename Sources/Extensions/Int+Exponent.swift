//
//  Int+Exponent.swift
//
//
//  Created by Will McGinty on 12/3/23.
//

import Foundation

public func pow (_ base: Int, _ exponent: UInt) -> Int {
    return (2...exponent).reduce(base) { result, _ in result * base }
}
