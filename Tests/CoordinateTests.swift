//
//  File.swift
//  
//
//  Created by Will McGinty on 12/17/23.
//

import Foundation
import XCTest
@testable import AdventKit

final class CoordinateTests: XCTestCase {
    
    func testCoordinateDirections() {
        let coordinate = Coordinate(x: 3, y: 3)
        for dir in Coordinate.Direction.allCases {
            let neighbor = coordinate.neighbor(in: dir)
            let calculatedDir = Coordinate.Direction(from: coordinate, toNeighbor: neighbor)
            let otherCalculatedDir = coordinate.direction(to: neighbor)
            
            XCTAssertEqual(calculatedDir, dir)
            XCTAssertEqual(otherCalculatedDir, dir)
        }
    }
}
