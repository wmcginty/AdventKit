//
//  Polygon.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import Algorithms
import Foundation

public struct Polygon {

    // MARK: - Properties
    public let vertices: [Coordinate]

    // MARK: - Initializer
    public init(vertices: [Coordinate]) {
        self.vertices = vertices
    }

    // MARK: - Interface

    /// https://www.themathdoctors.org/polygon-coordinates-and-areas/
    public func shoelaceArea() -> Double {
        let areas = vertices.adjacentPairs().map { Double(($0.1.y + $0.0.y) * ($0.1.x - $0.0.x)) }
        return abs(areas.reduce(0, +)) / 2
    }

    public func perimeter() -> Double {
        guard !vertices.isEmpty else { return 0 }

        let cycled = vertices + [vertices[0]]
        return cycled.adjacentPairs().map { $0.0.euclideanDistance(to: $0.1) }.reduce(0,+)
    }

    public func interiorLatticePoints() -> Int {
        let p = Int(perimeter())
        let a = Int(shoelaceArea())

        return a - (p / 2) + 1
    }
    public func sumOfBoundaryAndInteriorLatticePoints() -> Int {
        let p = Int(perimeter())
        let a = Int(shoelaceArea())

        return a + (p / 2) + 1
    }
}
