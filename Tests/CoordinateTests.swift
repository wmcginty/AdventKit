//
//  CoordinateTests.swift
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

    func testMovementEastWest() {
        let coordinate = Coordinate(x: 3, y: 3)
        let movedRight = coordinate.moved(in: .east, amount: 4)
        XCTAssertEqual(movedRight, .init(x: 7, y: 3))

        let limitedMovedRight = coordinate.moved(in: .east, amount: 4, horizontalLimit: .xLimit(0...5))
        XCTAssertEqual(limitedMovedRight, .init(x: 5, y: 3))
    }

    func testMovementNorthSouth() {
        let coordinate = Coordinate(x: 3, y: 3)
        let movedDown = coordinate.moved(in: .south, amount: 4)
        XCTAssertEqual(movedDown, .init(x: 3, y: 7))

        let limitedMovedDown = coordinate.moved(in: .south, amount: 4, verticalLimit: .yLimit(0...5))
        XCTAssertEqual(limitedMovedDown, .init(x: 3, y: 5))
    }
}
