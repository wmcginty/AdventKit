//
//  GridMap.swift
//
//
//  Created by Will McGinty on 12/3/23.
//

import Foundation

@dynamicMemberLookup
public struct GridMap<Element> {

    // MARK: - Properties
    public var grid: Grid<Element>
    public let start: Coordinate
    public let end: Coordinate
 
    // MARK: - Initializers
    
    /// Creates a new `GridMap` for use with an `AStarPathfinder`.
    /// - Parameters:
    ///   - grid: The grid that descripes that map to be navigated.
    ///   - start: The starting coordinate.
    ///   - end: The goal or end coordinate.
    public init(grid: Grid<Element>, start: Coordinate, end: Coordinate) {
        self.grid = grid
        self.start = start
        self.end = end
    }
    
    // MARK: - Interface
    public subscript<T>(dynamicMember keyPath: KeyPath<Grid<Element>, T>) -> T {
        return grid[keyPath: keyPath]
    }
    
    // MARK: - Interface
    public var rowCount: Int { return grid.rowCount }
    public func columnCount(for row: Int) -> Int { return grid.columnCount(for: row) }
    
    public var lastRowIndex: Int { return grid.lastRowIndex }
    public func lastColumnIndex(for row: Int) -> Int { return grid.lastColumnIndex(for: row) }
    
    public var rows: Range<Int> { return grid.rows }
    public func columns(for row: Int) -> Range<Int> { return grid.columns(for: row) }
    
    public var allCoordinates: [Coordinate] { return grid.allCoordinates }
    
    /// Accesses through the array storage, will throw exception when passed an out of bounds coordinate.
    public subscript(coordinate: Coordinate) -> Element {
        get { return grid[coordinate] }
        set { grid[coordinate] = newValue }
    }
    
    public func contentsOfRow(at index: Int) -> [Element] { return grid.contentsOfRow(at: index) }
    public func contentsOfColumn(at index: Int) -> [Element] { return grid.contentsOfColumn(at: index) }
    
    /// Accesses through the dictionary storage, will hand back `nil` for an out of bounds coordinate.
    public func contents(at coordinate: Coordinate) -> Element? { return grid.contents(at: coordinate) }
    
    public func neighbors(of coordinate: Coordinate, in directions: [Coordinate.Direction] = Coordinate.Direction.allCases,
                          matching predicate: (Element) throws -> Bool) rethrows -> Set<Coordinate> {
        return try grid.neighbors(of: coordinate, in: directions, matching: predicate)
    }
}

// MARK: - CustomStringConvertible
extension GridMap: CustomStringConvertible where Element: CustomStringConvertible {
    
    public var description: String {
        return grid.description
    }
}

