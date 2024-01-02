//
//  Coordinate.swift
//  
//
//  Created by Will McGinty on 12/20/22.
//

import Foundation

public struct Coordinate: Hashable, CustomStringConvertible {

    // MARK: - Coordinate.Direction
    public enum Direction: CaseIterable {
        case north, northEast, east, southEast, south, southWest, west, northWest

        public var isNorthOrSouth: Bool { return self == .north || self == .south }
        public var isEastOrWest: Bool { return self == .east || self == .west }
        
        public var inverse: Direction {
            switch self {
                
            case .north: return .south
            case .northEast: return .southWest
            case .east: return .west
            case .southEast: return .northWest
            case .south: return .north
            case .southWest: return .northEast
            case .west: return .east
            case .northWest: return .southEast
            }
        }
        
        // MARK: - Initializer
        init?(from: Coordinate, toNeighbor neighbor: Coordinate) {
            switch (neighbor.x - from.x, neighbor.y - from.y) {
            case (1, -1): self = .northEast
            case (1, 0): self = .east
            case (1, 1): self = .southEast
            case (0, 1): self = .south
            case (0, -1): self = .north
            case (-1, -1): self = .northWest
            case (-1, 0): self = .west
            case (-1, 1): self = .southWest
            default: return nil
            }
        }
    }

    // MARK: - Properties
    public var x, y: Int

    // MARK: - Initializers    
    public init(row: Int, column: Int) {
        self.init(x: column, y: row)
    }

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    // MARK: - Preset
    public static let zero = Self(x: 0, y: 0)

    // MARK: - CustomStringConvertible
    public var row: Int { return y }
    public var column: Int { return x }

    public var description: String { return "\(x),\(y)" }
}

// MARK: - Distance
// MARK: - Distance and Movement
public extension Coordinate {

    func manhattanDistance(to point: Coordinate) -> Int {
        return abs(x - point.x) + abs(y - point.y)
    }

    func euclideanDistance(to point: Coordinate) -> Double {
        let dX = Double(x - point.x)
        let dY = Double(y - point.y)
        return sqrt(dX * dX + dY * dY)
    }
}

// MARK: - Movement
public extension Coordinate {

    enum HorizontalLimit {
        case xLimit(Range<Int>)

        // MARK: - Interface
        public var range: Range<Int> {
            switch self {
            case .xLimit(let range): return range
            }
        }

        // MARK: - Preset
        public static func xLimit(_ limit: ClosedRange<Int>) -> HorizontalLimit { return .xLimit(Range(limit)) }
        public static func columnLimit(_ limit: Range<Int>) -> HorizontalLimit { return .xLimit(limit) }
        public static func columnLimit(_ limit: ClosedRange<Int>) -> HorizontalLimit { return .xLimit(limit) }
    }

    enum VerticalLimit {
        case yLimit(Range<Int>)

        // MARK: - Interface
        public var range: Range<Int> {
            switch self {
            case .yLimit(let range): return range
            }
        }

        // MARK: - Preset
        public static func yLimit(_ limit: ClosedRange<Int>) -> VerticalLimit { return .yLimit(Range(limit)) }
        public static func rowLimit(_ limit: Range<Int>) -> VerticalLimit { return .yLimit(limit) }
        public static func rowLimit(_ limit: ClosedRange<Int>) -> VerticalLimit { return .yLimit(limit) }
    }

    func moved(in direction: Direction, amount: Int, horizontalLimit: HorizontalLimit? = nil, verticalLimit: VerticalLimit? = nil) -> Coordinate {
        let coordinate = {
            switch direction {
            case .north: return Coordinate(x: x, y: y - amount)
            case .northEast: return Coordinate(x: x + amount, y: y - amount)
            case .east: return Coordinate(x: x + amount, y: y)
            case .southEast: return Coordinate(x: x + amount, y: y + amount)
            case .south: return Coordinate(x: x, y: y + amount)
            case .southWest: return Coordinate(x: x - amount, y: y + amount)
            case .west: return Coordinate(x: x - amount, y: y)
            case .northWest: return Coordinate(x: x - amount, y: y - amount)
            }
        }()

        return coordinate.limited(horizontally: horizontalLimit, vertically: verticalLimit)
    }

    func line(to end: Coordinate) -> [Coordinate] {
        let dX = (end.x - x).signum()
        let dY = (end.y - y).signum()
        let range = max(abs(x - end.x), abs(y - end.y))
        return (0..<range).map { Coordinate(x: x + dX * $0, y: y + dY * $0) }
    }

    func limited(horizontally hLimit: HorizontalLimit?, vertically yLimit: VerticalLimit?) -> Coordinate {
        return Coordinate(
            x: hLimit.map {
                let range = $0.range
                return min(range.upperBound - 1, max(x, range.lowerBound)) } ?? x,
            y: yLimit.map {
                let range = $0.range
                return min(range.upperBound - 1, max(y, range.lowerBound)) } ?? y
        )
    }
}

// MARK: Coordinate + Neighbors, Directions
public extension Coordinate {

    func isAdjacent(to other: Coordinate) -> Bool {
        return abs(x - other.x) <= 1 && abs(y - other.y) <= 1
    }

    func neighbor(in direction: Direction) -> Coordinate {
        switch direction {
        case .north: return Coordinate(x: x, y: y - 1)
        case .northEast: return Coordinate(x: x + 1, y: y - 1)
        case .east: return Coordinate(x: x + 1, y: y)
        case .southEast: return Coordinate(x: x + 1, y: y + 1)
        case .south: return Coordinate(x: x, y: y + 1)
        case .southWest: return Coordinate(x: x - 1, y: y + 1)
        case .west: return Coordinate(x: x - 1, y: y)
        case .northWest: return Coordinate(x: x - 1, y: y - 1)
        }
    }

    func neighbors(in directions: [Direction] = Direction.allCases) -> Set<Coordinate> {
        return Set(directions.map(neighbor(in:)))
    }
    
    func direction(to neighbor: Coordinate) -> Direction? {
        return Direction(from: self, toNeighbor: neighbor)
    }
}

// MARK: - Coordinate.Direction + Cardinal
public extension Coordinate.Direction {
    var isCardinal: Bool { return [Self].cardinal.contains(self) }
}

public extension Array where Element == Coordinate.Direction {
    static let cardinal: [Element] = [.north, .south, .east, .west]
}
