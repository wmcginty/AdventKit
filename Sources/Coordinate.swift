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
    public let x, y: Int

    // MARK: - Initializers
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(row: Int, column: Int) {
        self.init(x: column, y: row)
    }

    // MARK: - CustomStringConvertible
    public var row: Int { return y }
    public var column: Int { return x }

    public var description: String { return "\(x),\(y)" }
}

// MARK: - Distance and Movement
public extension Coordinate {

    func manhattanDistance(to point: Coordinate) -> Int {
        return abs(x - point.x) + abs(y - point.y)
    }

    func moved(in direction: Direction, amount: Int, xLimit: Range<Int>? = nil, yLimit: Range<Int>? = nil) -> Coordinate {
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
        
        return coordinate.limited(inX: xLimit, y: yLimit)
    }
    
    func moved(in direction: Direction, amount: Int, rowLimit: Range<Int>? = nil, columnLimit: Range<Int>? = nil) -> Coordinate {
        return moved(in: direction, amount: amount, xLimit: columnLimit, yLimit: rowLimit)
    }

    func line(to end: Coordinate) -> [Coordinate] {
        let dX = (end.x - x).signum()
        let dY = (end.y - y).signum()
        let range = max(abs(x - end.x), abs(y - end.y))
        return (0..<range).map { Coordinate(x: x + dX * $0, y: y + dY * $0) }
    }
    
    func limited(inX xLimit: Range<Int>?, y yLimit: Range<Int>?) -> Coordinate {
        return Coordinate(x: xLimit.map { min($0.upperBound, max(x,$0.lowerBound)) } ?? x,
                          y: yLimit.map { min($0.upperBound, max(y,$0.lowerBound)) } ?? y)
    }
    
    func limited(inRow rowLimit: Range<Int>?, column columnLimit: Range<Int>?) -> Coordinate {
        return limited(inX: columnLimit, y: rowLimit)
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
