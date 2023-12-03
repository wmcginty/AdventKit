//
//  Grid.swift
//
//
//  Created by Will McGinty on 12/3/23.
//

import Foundation

public struct Grid<Element> {
    
    // MARK: - Properties
    public let contents: [[Element]]
    public let dictionary: [Coordinate: Element]
    
    // MARK: - Initializer
    public init(contents: [[Element]]) {
        self.contents = contents
        self.dictionary = zip(contents.indices, contents).reduce(into: [:], { partialResult, element in
            let (row, rowContents) = element
            zip(rowContents.indices, rowContents).forEach { col, contents in
                partialResult[Coordinate(x: col, y: row)] = contents
            }
        })
    }

    // MARK: - Interface
    public var rowCount: Int { return contents.count }
    public func columnCount(for row: Int) -> Int { return contents[row].count }
    
    public var rows: Range<Int> { return 0..<rowCount }
    public func columns(for row: Int) -> Range<Int> { return 0..<columnCount(for: row) }
    
    public var allCoordinates: [Coordinate] {
        return rows.flatMap { row in
            columns(for: row).map { Coordinate(row: row, column: $0) }
        }
    }
    
    public func contentsOfRow(at index: Int) -> [Element] { return contents[index] }
    public func contentsOfColumn(at index: Int) -> [Element] { return contents.map { $0[index] } }
    public func contents(at coordinate: Coordinate) -> Element? { return dictionary[coordinate] }
}

// MARK: - CustomStringConvertible
extension Grid: CustomStringConvertible where Element: CustomStringConvertible {
    
    public var description: String {
        var result = ""
        for row in rows {
            for column in columns(for: row) {
                if let contents = contents(at: .init(row: row, column: column)) {
                    result += contents.description
                }
            }
            
            result += "\n"
        }
        
        return result
    }
}
