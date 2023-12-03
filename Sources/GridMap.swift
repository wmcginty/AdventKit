//
//  GridMap.swift
//
//
//  Created by Will McGinty on 12/3/23.
//

import Foundation

public struct GridMap<Element>: Pathfinding {

    // MARK: - Properties
    public let grid: Grid<Element>
    public let start: Coordinate
    public let end: Coordinate
    
    private let neighbors: (Coordinate) -> Set<Coordinate>
    private let costToMove: (_ from: Coordinate, _ to: Coordinate) -> Int
    private let distance: (_ from: Coordinate, _ to: Coordinate) -> Int

    // MARK: - Initializers
    
    /// Creates a new `GridMap` for use with an `AStarPathfinder`.
    /// - Parameters:
    ///   - grid: The grid that descripes that map to be navigated.
    ///   - start: The starting coordinate.
    ///   - end: The goal or end coordinate.
    ///   - neighbors: A set of available neighbors that can be moved to from the given `Coordinate`.
    ///   - costToMove: A function that calculates the cost to move from a given `Coordinate` to another. Defaults to `1`.
    ///   - distance: A function that calculates the distance between a given `Coordinate` and another. Defaults to Manhattan distance.
    public init(grid: Grid<Element>, start: Coordinate, end: Coordinate,
                neighbors: @escaping (Coordinate) -> Set<Coordinate>,
                costToMove: @escaping (_ from: Coordinate, _ to: Coordinate) -> Int = { _,_ in 1 },
                distance: @escaping (_ from: Coordinate, _ to: Coordinate) -> Int = { $0.manhattanDistance(to: $1) }) {
        self.grid = grid
        self.start = start
        self.end = end
        
        self.neighbors = neighbors
        self.costToMove = costToMove
        self.distance = distance
    }

    // MARK: - Pathfinding
    public func neighbors(for coordinate: Coordinate) -> Set<Coordinate> {
        return neighbors(coordinate)
    }

    public func costToMove(from: Coordinate, to: Coordinate) -> Int {
        return costToMove(from, to)
    }

    public func distance(from: Coordinate, to: Coordinate) -> Int {
        return distance(from, to)
    }
}
