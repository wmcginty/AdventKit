//
//  SignedInteger+LeastCommonMultiple.swift
//
//
//  Created by Will McGinty on 12/24/22.
//

import Foundation

public extension SignedInteger {

    func greatestCommonDenominator(with other: Self) -> Self {
        let r = self % other
        if r != 0 {
            return other.greatestCommonDenominator(with: r)
        } else {
            return other
        }
    }

    func leastCommonMultiple(with other: Self) -> Self {
        return self / greatestCommonDenominator(with: other) * other
    }
}

public extension Array where Element: SignedInteger {
    
    var greatestCommonDenominator: Element? {
        guard !isEmpty else { return nil }
        guard let first, count > 1 else { return first }
        
        return reduce(first) { $0.greatestCommonDenominator(with: $1) }
    }

    var leastCommonMultiple: Element? {
        guard !isEmpty else { return nil }
        guard let first, count > 1 else { return first }
        
        return reduce(first) { $0.leastCommonMultiple(with: $1) }
    }
}
