//
//  PathfindTests.swift
//
//
//  Created by Will McGinty on 12/17/23.
//

import XCTest
@testable import AdventKit

final class PathfindTests: XCTestCase {
    
    let basicGrid = """
        ....
        ....
        ....
        ....
        """
    
    struct StringGrid: Pathfindable {
        let grid: Grid<String>
        
        public func neighbors(for coordinate: Coordinate, moving direction: Coordinate.Direction?) -> Set<Coordinate> {
            return coordinate.neighbors(in: .cardinal)
        }
    }
    
    func testSimpleAStar() {
        let contents = basicGrid.lines().map { $0.map(String.init) }
        let stringGrid = StringGrid(grid: .init(contents: contents))
        let pathfinder = AStarPathfinder(map: stringGrid)
        let shortestPath = pathfinder.shortestPath(from: .init(x: 0, y: 0),
                                                   to: .init(row: stringGrid.grid.lastRowIndex,
                                                             column: stringGrid.grid.lastColumnIndex(forRow: 0)))
        
        print(stringGrid.grid.description { c, _ in
            return shortestPath?.contains(c) == true ? "X" : nil
        })
        
        XCTAssertEqual(shortestPath?.count, 7)
        XCTAssertTrue(shortestPath?.contains(.init(x: 0, y: 0)) == true)
        XCTAssertTrue(shortestPath?.contains(.init(x: 3, y: 3)) == true)
    }
    
    let weightedGrid = """
        1222
        1222
        1222
        1111
        """
    
    let stronglyWeightedGrid = """
        19111
        19191
        19191
        11191
        """

    struct IntGrid: Pathfindable {
        let grid: Grid<Int>
        
        public func neighbors(for coordinate: Coordinate, moving direction: Coordinate.Direction?) -> Set<Coordinate> {
            return coordinate.neighbors(in: .cardinal)
                .filter { grid.contents(at: $0) != nil }
        }
        
        public func costToMove(from: Coordinate, to: Coordinate) -> Int {
            grid[to]
        }
    }

    func testWeightedAStar() {
        let contents = weightedGrid.lines().map { $0.map { Int(String($0))! } }
        let intGrid = IntGrid(grid: .init(contents: contents))
        let pathfinder = AStarPathfinder(map: intGrid)
        let shortestPath = pathfinder.shortestPath(from: .init(x: 0, y: 0),
                                                   to: .init(row: intGrid.grid.lastRowIndex,
                                                             column: intGrid.grid.lastColumnIndex(forRow: 0)))
        
        print(intGrid.grid.description { c, _ in
            return shortestPath?.contains(c) == true ? "X" : nil
        })
        
        XCTAssertEqual(shortestPath?.count, 7)
        XCTAssertTrue(shortestPath?.contains(.init(x: 0, y: 0)) == true)
        XCTAssertTrue(shortestPath?.contains(.init(x: 3, y: 3)) == true)
    }
    
    func testStronglyWeightedAStar() {
        let contents = stronglyWeightedGrid.lines().map { $0.map { Int(String($0))! } }
        let intGrid = IntGrid(grid: .init(contents: contents))
        let pathfinder = AStarPathfinder(map: intGrid)
        let shortestPath = pathfinder.shortestPath(from: .init(x: 0, y: 0),
                                                   to: .init(row: intGrid.grid.lastRowIndex,
                                                             column: intGrid.grid.lastColumnIndex(forRow: 0)))
        
        print(intGrid.grid.description { c, _ in
            return shortestPath?.contains(c) == true ? "X" : nil
        })
        
        XCTAssertEqual(shortestPath?.count, 14)
        XCTAssertTrue(shortestPath?.contains(.init(x: 0, y: 0)) == true)
        XCTAssertTrue(shortestPath?.contains(.init(x: 4, y: 3)) == true)
    }
}
