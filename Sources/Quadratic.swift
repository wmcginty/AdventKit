//
//  Quadratic.swift
//
//
//  Created by Will McGinty on 12/21/23.
//

import Foundation

public struct Quadratic {

    public static func interpolatedValue(givenF0 f0: Int, f1: Int, f2: Int, x: Int) -> Int {
        /* General Method:
         1) Assume you have the values output by a function at three successive points, call them f0, f1, f2.
         2) Calculate the first differences between them, f1 - f0 and f2 - f2
         3) Calculate the second difference, d2 - d1
         4) Use the formula to interpolate a value at `x`: f(x) = f(0) + (d1 *  x)) + (x * (x - 1) / 2) * (d2 - d1)
         */

        let d1 = f1 - f0
        let d2 = f2 - f1
        return f0 + d1 * x + (x * (x - 1) / 2) * (d2 - d1)
    }
}
