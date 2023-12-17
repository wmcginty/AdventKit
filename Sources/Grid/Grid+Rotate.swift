//
//  Grid+Rotate.swift
//
//
//  Created by Will McGinty on 12/14/23.
//

import Foundation

public extension Grid {

    func rotatedClockwise() -> Self {
        guard !contents.isEmpty else { return self }

        var rotated = [[Element]]()
        for column in columns(forRow: 0) {
            var rotatedRow = [Element]()
            for row in rows.reversed() {
                rotatedRow.append(contents[row][column])
            }

            rotated.append(rotatedRow)
        }

        return .init(contents: rotated)
    }

    mutating func rotateClockwise() {
        let copy = self.rotatedClockwise()
        self = copy
    }
}
