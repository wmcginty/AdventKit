//
//  Int+Exponent.swift
//
//
//  Created by Will McGinty on 12/3/23.
//

import Foundation

precedencegroup ExponentPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : ExponentPrecedence
public func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(radix, power))
}

public func pow (_ base: Int, _ exponent: Int) -> Int {
    return (2...exponent).reduce(base) { result, _ in result * base }
}
