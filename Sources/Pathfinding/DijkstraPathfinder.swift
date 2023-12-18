//
//  DijkstraPathfinder.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import Foundation

struct DijkstraPathfinder<State: Hashable> {

//    private final class PathNode: Comparable, CustomStringConvertible {
//
//        // MARK: - Coordinates
//        let state: State
//        let parent: PathNode?
//
//        let distance: Int // Distance from start to node
//
//        // MARK: - Initializer
//        init(state: Coordinate, parent: PathNode? = nil, moveCost: Int = 0, hScore: Int = 0) {
//            self.coordinate = coordinate
//            self.parent = parent
//            self.gScore = (parent?.gScore ?? 0) + moveCost
//            self.hScore = hScore
//        }
//
//        static func == (lhs: PathNode, rhs: PathNode) -> Bool {
//            lhs.coordinate == rhs.coordinate
//        }
//
//        static func < (lhs: PathNode, rhs: PathNode) -> Bool {
//            lhs.fScore < rhs.fScore
//        }
//
//        // MARK: - CustomStringConvertible
//        var description: String {
//            "pos=\(coordinate) g=\(gScore) h=\(hScore) f=\(fScore)"
//        }
//    }

    struct Distanced: Comparable, Hashable {
        let state: State
        let distance: Int

        public static func < (lhs: Distanced, rhs: Distanced) -> Bool {
            return lhs.distance < rhs.distance
        }
    }

    struct StateCost {
        let state: State
        let cost: Int
    }

    // MARK: - Properties
    let nextStateGenerator: (State) -> [StateCost]

    // MARK: - Initializer
    init(nextStates: @escaping (State) -> [StateCost]) {
        self.nextStateGenerator = nextStates
    }

    // MARK: - Interface
    func shortestPath(from initialState: State, toTarget targetPredicate: (State) -> Bool) -> Int? {
        var dictionary: Dictionary<State, Int> = [:]
        var priorityQueue = Heap<Distanced>([.init(state: initialState, distance: 0)])

        while let next = priorityQueue.popMin() {
            if dictionary[next.state] != nil {
                continue  // We already have a distance for this state, we can skip re-computation
            }
            dictionary[next.state] = next.distance

            if targetPredicate(next.state) {
                return next.distance
            }

            for stateCost in nextStateGenerator(next.state) {
                priorityQueue.insert(.init(state: stateCost.state, distance: next.distance + stateCost.cost))
            }
        }

        return nil
    }


}

//extension Grid<Int> {
//
//    struct State: Hashable {
//        let coordinate: Coordinate
//        let direction: Coordinate.Direction?
//        let consecutiveInDirection: Int
//    }
//
//    struct Distanced<T: Hashable>: Comparable, Hashable {
//        let state: T
//        let distance: Int
//
//        public static func < (lhs: Distanced, rhs: Distanced) -> Bool {
//            return lhs.distance < rhs.distance
//        }
//    }
//
//    func minimumHeatLoss(from coordinate: Coordinate, to target: Coordinate, part1: Bool) -> Int? {
//        var dictionary: Dictionary<State, Int> = [:]
//        var priorityQueue = Heap<Distanced<State>>([.init(state: .init(coordinate: coordinate,
//                                                                       direction: nil,
//                                                                       consecutiveInDirection: 0),
//                                                          distance: 0)])
//
//        while let next = priorityQueue.popMin() {
//            if dictionary[next.state] != nil {
//                continue  // We already have a distance for this state, we can skip re-computation
//            }
//            dictionary[next.state] = next.distance
//
//            if next.state.coordinate == target {
//                return next.distance
//            }
//
//            let validDirections: [Coordinate.Direction] = .cardinal.filter { $0 != next.state.direction?.inverse }
//            for direction in validDirections {
//                let nextCoordinate = next.state.coordinate.neighbor(in: direction)
//                let newDirection = direction
//                let newConsecutive = newDirection == next.state.direction ? next.state.consecutiveInDirection + 1 : 1
//
//                var isValid: Bool
//                if part1 {
//                    isValid = newConsecutive <= 3
//                } else {
//                    isValid = newConsecutive <= 10 && (newDirection == next.state.direction || next.state.consecutiveInDirection >= 4 || next.state.consecutiveInDirection == 0)
//                }
//
//                if let cost = grid.contents(at: nextCoordinate), isValid {
//                    priorityQueue.insert(.init(state: .init(coordinate: nextCoordinate,
//                                                            direction: newDirection,
//                                                            consecutiveInDirection: newConsecutive),
//                                               distance: next.distance + cost))
//                }
//            }
//        }
//
//        return nil
//    }
//}
//
//let lines = String.input.lines()
//let contents = lines.map { $0.map( { Int(String($0))! }) }
//let grid = Grid(contents: contents)
//
//measure(part: .one) { logger in
//    /* Part One */
//    return grid.minimumHeatLoss(from: .zero, to: .init(row: grid.lastRowIndex, column: grid.lastColumnIndex(forRow: 0)), part1: true) ?? 0
//}
//
//measure(part: .two) { logger in
//    /* Part Two */
//    return grid.minimumHeatLoss(from: .zero, to: .init(row: grid.lastRowIndex, column: grid.lastColumnIndex(forRow: 0)), part1: false) ?? 0
//}
