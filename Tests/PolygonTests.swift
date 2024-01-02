//
//  PolygonTests.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import Foundation

import XCTest
@testable import AdventKit

final class PolygonTests: XCTestCase {

    let sampleCoordinates: [Coordinate] = [(0,0), (6,0), (6,5), (4,5), (4,7), (6,7), (6,9),
                                           (1,9), (1,7), (0,7), (0,5), (2,5), (2,2), (0,2)].map(Coordinate.init(x:y:))

    func testPolygon_perimeter() {
        let polygon = Polygon(vertices: sampleCoordinates)
        XCTAssertEqual(polygon.perimeter(), 38)
    }

    func testPolygon_shoelaceArea() {
        let polygon = Polygon(vertices: sampleCoordinates)
        XCTAssertEqual(polygon.shoelaceArea(), 42)
    }

    func testPolygon_interiorLatticePoints() {
        let polygon = Polygon(vertices: sampleCoordinates)
        XCTAssertEqual(polygon.interiorLatticePoints(), 24)
    }

    func testPolygon_sumOfBoundaryAndInteriorLatticePoints() {
        let polygon = Polygon(vertices: sampleCoordinates)
        XCTAssertEqual(polygon.sumOfBoundaryAndInteriorLatticePoints(), 62)
    }
}
