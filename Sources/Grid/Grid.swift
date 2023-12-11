//
//  Grid.swift
//
//
//  Created by Will McGinty on 12/3/23.
//

import Foundation

public struct Grid<Element> {
    
    // MARK: - Properties
    public private(set) var contents: [[Element]]
    public private(set) var dictionary: [Coordinate: Element]
    
    // MARK: - Initializer
    public init(contents: [[Element]]) {
        self.contents = contents
        self.dictionary = zip(contents.indices, contents).reduce(into: [:], { partialResult, element in
            let (row, rowContents) = element
            zip(rowContents.indices, rowContents).forEach { col, contents in
                partialResult[Coordinate(row: row, column: col)] = contents
            }
        })
    }

    // MARK: - Interface
    public var rowCount: Int { return contents.count }
    public func columnCount(for row: Int) -> Int { return contents[row].count }
    
    public var lastRowIndex: Int { return rowCount - 1 }
    public func lastColumnIndex(for row: Int) -> Int { return columnCount(for: row) - 1 }
    
    public var rows: Range<Int> { return 0..<rowCount }
    public func columns(for row: Int) -> Range<Int> { return 0..<columnCount(for: row) }
    
    public var allCoordinates: [Coordinate] {
        return rows.flatMap { row in
            columns(for: row).map { Coordinate(row: row, column: $0) }
        }
    }
    
    public subscript(coordinate: Coordinate) -> Element {
        get { return contents[coordinate.row][coordinate.column] }
        set {
            contents[coordinate.row][coordinate.column] = newValue
            dictionary[coordinate] = newValue
        }
    }
    
    public func contentsOfRow(at index: Int) -> [Element] { return contents[index] }
    public func contentsOfColumn(at index: Int) -> [Element] { return contents.map { $0[index] } }
    public func contents(at coordinate: Coordinate) -> Element? { return dictionary[coordinate] }
    
    public func neighbors(of coordinate: Coordinate, in directions: [Coordinate.Direction] = Coordinate.Direction.allCases,
                          matching predicate: (Element) throws -> Bool) rethrows -> Set<Coordinate> {
        return Set(try coordinate.neighbors(in: directions).filter { try predicate(self[$0]) })
    }
    
    public func map<T>(_ transform: (Element) throws -> T) rethrows -> Grid<T> {
        return Grid<T>(contents: try contents.map { try $0.map(transform) })
    }

    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        return try allCoordinates.filter { try predicate(self[$0]) }.count
    }
}

// MARK: - CustomStringConvertible
extension Grid: CustomStringConvertible where Element: CustomStringConvertible {
    
    public func description(with additionalPredicate: (Coordinate, Element) -> String?) -> String {
        var result = ""
        for row in rows {
            for column in columns(for: row) {
                let coordinate = Coordinate(row: row, column: column)
                let content = self[coordinate]
                result += additionalPredicate(coordinate, content) ?? content.description
            }
            
            if row < rows.upperBound - 1 {
                result += "\n"
            }
        }
        
        return result
    }
    
    public var description: String {
        var result = ""
        for row in rows {
            for column in columns(for: row) {
                let coordinate = Coordinate(row: row, column: column)
                result += self[coordinate].description
            }
            
            if row < rows.upperBound - 1 {
                result += "\n"
            }
        }
        
        return result
    }
}
