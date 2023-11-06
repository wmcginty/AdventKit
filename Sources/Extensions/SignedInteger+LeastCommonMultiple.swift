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
