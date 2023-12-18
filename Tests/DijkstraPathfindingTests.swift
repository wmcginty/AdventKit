//
//  DijkstraPathfindingTests.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import XCTest
@testable import AdventKit

final class DijkstraPathfindingTests: XCTestCase {

    let basicGrid = """
        ....
        ....
        ....
        ....
        """

    func testSimpleDijkstra() {
        let contents = basicGrid.lines().map { $0.map { String($0) } }
        let grid = Grid(contents: contents)
        let pathfinder = DijkstraPathfinder.distances { (currentState: Coordinate) in
            let validDirections: [Coordinate.Direction] = .cardinal

            return validDirections.compactMap { direction in
                let nextCoordinate = currentState.neighbor(in: direction)

                guard grid.dictionary[nextCoordinate] != nil else { return nil }
                return .init(state: nextCoordinate, cost: 1)
            }
        }

        let shortestPath = pathfinder.shortestPath(from: .zero, toTarget: { $0 == grid.bottomRight })

        print(grid.description(of: shortestPath, displayedWith: "X"))
        XCTAssertEqual(shortestPath?.overallCost, 6)
        XCTAssertEqual(shortestPath?.states.count, 7)
    }

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

    func testWeightedDijkstra() {
        struct State: Hashable {
            let coordinate: Coordinate
            let direction: Coordinate.Direction?
            let consecutiveInDirection: Int
        }

        let contents = weightedGrid.lines().map { $0.map { Int(String($0))! } }
        let grid = Grid(contents: contents)
        let pathfinder = DijkstraPathfinder<State, Int> { currentState in
            let validDirections: [Coordinate.Direction] = .cardinal.filter { $0 != currentState.direction?.inverse }
            return validDirections.compactMap { direction in
                let nextCoordinate = currentState.coordinate.neighbor(in: direction)
                let newDirection = direction
                let newConsecutive = newDirection == currentState.direction ? currentState.consecutiveInDirection + 1 : 1
                let isValid = newConsecutive <= 3

                guard let cost = grid.contents(at: nextCoordinate), isValid else { return nil }
                return .init(state: .init(coordinate: nextCoordinate, direction: newDirection, consecutiveInDirection: newConsecutive), cost: cost)
            }
        }

        let shortestPath = pathfinder.shortestPath(from: .init(coordinate: .zero, direction: nil, consecutiveInDirection: 0),
                                                   toTarget: { $0.coordinate == grid.bottomRight })

        print(grid.description(of: shortestPath, displayedWith: ".", convertedBy: { $0.coordinate }))
        XCTAssertEqual(shortestPath?.overallCost, 102)
        XCTAssertEqual(shortestPath?.states.count, 29)
        XCTAssertTrue(shortestPath?.states.map(\.coordinate).contains(.init(x: 5, y: 0)) == true)
        XCTAssertTrue(shortestPath?.states.map(\.coordinate).contains(.init(x: 12, y: 10)) == true)
    }
}
