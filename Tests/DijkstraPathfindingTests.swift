//
//  DijkstraPathfindingTests.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import XCTest
@testable import AdventKit

final class DijkstraPathfindingTests: XCTestCase {

    let weightedGrid = """
        2413432311323
        3215453535623
        3255245654254
        3446585845452
        4546657867536
        1438598798454
        4457876987766
        3637877979653
        4654967986887
        4564679986453
        1224686865563
        2546548887735
        4322674655533
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

    func testWeightedDijkstra() {
        struct State: Hashable {
            let coordinate: Coordinate
            let direction: Coordinate.Direction?
            let consecutiveInDirection: Int
        }

        let contents = weightedGrid.lines().map { $0.map { Int(String($0))! } }
        let intGrid = IntGrid(grid: .init(contents: contents))
        let pathfinder = DijkstraPathfinder<State> { currentState in
            let validDirections: [Coordinate.Direction] = .cardinal.filter { $0 != currentState.direction?.inverse }
            return validDirections.compactMap { direction in
                let nextCoordinate = currentState.coordinate.neighbor(in: direction)
                let newDirection = direction
                let newConsecutive = newDirection == currentState.direction ? currentState.consecutiveInDirection + 1 : 1
                let isValid = newConsecutive <= 3

                guard let cost = intGrid.grid.contents(at: nextCoordinate), isValid else { return nil }
                return .init(state: .init(coordinate: nextCoordinate, direction: newDirection, consecutiveInDirection: newConsecutive), cost: cost)
            }
        }

        let shortestPath = pathfinder.shortestPath(from: .init(coordinate: .zero, direction: nil, consecutiveInDirection: 0),
                                                   toTarget: { $0.coordinate == .init(x: intGrid.grid.lastRowIndex,
                                                                                      y: intGrid.grid.lastColumnIndex(forRow: 0)) })
//
//        print(intGrid.grid.description { c, _ in
//            return shortestPath?.contains(c) == true ? "X" : nil
//        })
//
        XCTAssertEqual(shortestPath, 102)
//        XCTAssertTrue(shortestPath?.contains(.init(x: 0, y: 0)) == true)
//        XCTAssertTrue(shortestPath?.contains(.init(x: 3, y: 3)) == true)
    }
}
