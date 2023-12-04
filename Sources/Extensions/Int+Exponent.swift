//
//  Int+Exponent.swift
//
//
//  Created by Will McGinty on 12/3/23.
//

import Foundation

precedencegroup ExponentPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : ExponentPrecedence
public func ^^ (radix: Int, exponent: Int) -> Int {
    return Int(pow(Double(radix), Double(exponent)))
}
