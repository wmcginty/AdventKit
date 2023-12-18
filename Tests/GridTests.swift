//
//  GridTests.swift
//
//
//  Created by Will McGinty on 12/17/23.
//

import XCTest
@testable import AdventKit

final class GridTests: XCTestCase {
    
    enum Content: String, CaseIterable, CustomStringConvertible {
        case path = "⬜️", wall = "⬛️", water = "🟦"
        
        var description: String { return rawValue }
    }

    func testRotateClockwise() {
        let grid: Grid<Int> = .init(contents: [
        [1, 1, 1, 1],
        [2, 2, 2, 2],
        [3, 4, 5, 6]
        ])

        let rotated = grid.rotatedClockwise()
        XCTAssertEqual(rotated.contents, [[3, 2, 1],
                                          [4, 2, 1],
                                          [5, 2, 1],
                                          [6, 2, 1]])
    }

    func testFloodFill_cardinalDirections() throws {
        let grid = Grid<Content>(contents:
                                    [[.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .wall, .path, .path, .path, .path],
                                     [.wall, .wall, .path, .path, .path, .wall, .wall],
                                     [.path, .path, .path, .path, .wall, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path]])
        
        let flooded = grid.floodFilled(with: .water, startingAt: .init(x: 3, y: 3),
                                       canFloodEvaluator: { $1.element == .path })
        
        let expectation = """
⬜️⬜️⬜️⬛️🟦🟦🟦
⬜️⬜️⬜️⬛️🟦🟦🟦
⬜️⬜️⬛️🟦🟦🟦🟦
⬛️⬛️🟦🟦🟦⬛️⬛️
🟦🟦🟦🟦⬛️⬜️⬜️
🟦🟦🟦⬛️⬜️⬜️⬜️
🟦🟦🟦⬛️⬜️⬜️⬜️
"""
        
        XCTAssertEqual(flooded.description, expectation)
    }
    
    func testFloodFill_allDirections() throws {
        let grid = Grid<Content>(contents:
                                    [[.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .wall, .path, .path, .path, .path],
                                     [.wall, .wall, .path, .path, .path, .wall, .wall],
                                     [.path, .path, .path, .path, .wall, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path]])
        
        let flooded = grid.floodFilled(with: .water, startingAt: .init(x: 3, y: 3),
                                       validNeighborDirections: Coordinate.Direction.allCases,
                                       canFloodEvaluator: { $1.element == .path })
        
        let expectation = """
🟦🟦🟦⬛️🟦🟦🟦
🟦🟦🟦⬛️🟦🟦🟦
🟦🟦⬛️🟦🟦🟦🟦
⬛️⬛️🟦🟦🟦⬛️⬛️
🟦🟦🟦🟦⬛️🟦🟦
🟦🟦🟦⬛️🟦🟦🟦
🟦🟦🟦⬛️🟦🟦🟦
"""
        
        XCTAssertEqual(flooded.description, expectation)
    }
    
    func testFloodFill_returningFloodResults() throws {
        let grid = Grid<Content>(contents:
                                    [[.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .wall, .path, .path, .path, .path],
                                     [.wall, .wall, .path, .path, .path, .wall, .wall],
                                     [.path, .path, .path, .path, .wall, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path]])
        
        let flooded = grid.floodFilled(startingAt: .init(x: 3, y: 3),
                                       canFloodEvaluator: { $1.element == .path })
        
        let description = flooded.description { coordinate, content in
            if content.isFilled {
                return "🟧"
            }
            
            return nil
        }
                                              
        let expectation = """
⬜️⬜️⬜️⬛️🟧🟧🟧
⬜️⬜️⬜️⬛️🟧🟧🟧
⬜️⬜️⬛️🟧🟧🟧🟧
⬛️⬛️🟧🟧🟧⬛️⬛️
🟧🟧🟧🟧⬛️⬜️⬜️
🟧🟧🟧⬛️⬜️⬜️⬜️
🟧🟧🟧⬛️⬜️⬜️⬜️
"""
        XCTAssertEqual(description, expectation)
    }
}
