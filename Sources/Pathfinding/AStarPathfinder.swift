//
//  AStarPathfinder.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import Foundation
import Collections

public class AStarPathfinder<State: Hashable, Cost: Numeric & Comparable> {

    public typealias StateCost = Pathfinder.StateCost<State, Cost>
    public typealias Path = Pathfinder.Path<State, Cost>

    private final class PathNode: Comparable, CustomStringConvertible {

        // MARK: - Coordinates
        let state: State
        let moveCost: Cost // Cost from parent to node
        let parent: PathNode?

        let gScore: Cost // Cost from start to node
        let hScore: Cost // Heuristic cost from node to destination
        var fScore: Cost { gScore + hScore }

        // MARK: - Initializer
        init(state: State, parent: PathNode? = nil, moveCost: Cost = 0, heuristicCost: Cost = 0) {
            self.state = state
            self.moveCost = moveCost
            self.parent = parent
            self.gScore = (parent?.gScore ?? 0) + moveCost
            self.hScore = heuristicCost
        }

        // MARK: - Interface
        var currentCost: Cost { return gScore }
        var estimatedRemainingCost: Cost { return hScore }
        var estimatedTotalCost: Cost { return fScore }

        var fullPath: Path {
            var result: [PathNode] = []
            var node: PathNode? = self
            while let n = node {
                result.append(n)
                node = n.parent
            }

            return Path(nodes: result.reversed().map { .init(state: $0.state, incrementalCost: $0.moveCost, totalCost: $0.gScore) })
        }

        // MARK: - Equatable
        static func == (lhs: PathNode, rhs: PathNode) -> Bool {
            lhs.state == rhs.state
        }

        // MARK: - Comparable
        static func < (lhs: PathNode, rhs: PathNode) -> Bool {
            lhs.fScore < rhs.fScore
        }

        // MARK: - CustomStringConvertible
        var description: String {
            "state=\(state) g=\(gScore) h=\(hScore) f=\(fScore)"
        }
    }

    // MARK: - Properties
    public let nextStateGenerator: (State) -> [StateCost]
    public var debugEnabled: Bool = false

    // MARK: - Initializer
    public init(nextStates: @escaping (State) -> [StateCost]) {
        self.nextStateGenerator = nextStates
    }

    // MARK: - Interface
    public func shortestCost(from initialState: State, toPossibleTargets targetStates: [State], heuristic: (State) -> Cost) -> Cost? {
        return shortestPath(from: initialState, toTarget: { targetStates.contains($0) }, heuristic: heuristic)?.overallCost
    }

    public func shortestPath(from initialState: State, toPossibleTargets targetStates: [State], heuristic: (State) -> Cost) -> Path? {
        return shortestPath(from: initialState, toTarget: { targetStates.contains($0) }, heuristic: heuristic)
    }

    public func shortestCost(from initialState: State, toTarget targetPredicate: (State) -> Bool, heuristic: (State) -> Cost) -> Cost? {
        return shortestPath(from: initialState, toTarget: targetPredicate, heuristic: heuristic)?.overallCost
    }

    public func shortestPath(from initialState: State, toTarget targetPredicate: (State) -> Bool, heuristic: (State) -> Cost) -> Path? {
        let initialStateHeuristic = heuristic(initialState)
        var priorityQueue = Heap<PathNode>([.init(state: initialState, heuristicCost: initialStateHeuristic)])
        var explored: [State: Cost] = [initialState: 0]

        while let next = priorityQueue.popMin() {
            if debugEnabled {
                debugPrint("Current: \(next)")
                debugPrint("Parent: \(String(describing: next.parent))")
                debugPrint()
            }

            if targetPredicate(next.state) {
                return next.fullPath
            }

            for stateCost in nextStateGenerator(next.state) {
                assert(stateCost.cost >= 0, "Negative costs are disallowed.")

                let newCost = next.gScore + stateCost.cost
                if explored[stateCost.state] == nil || explored[stateCost.state].map({ $0 > newCost }) == true {
                    explored[stateCost.state] = newCost
                    priorityQueue.insert(.init(state: stateCost.state, parent: next, moveCost: stateCost.cost, heuristicCost: heuristic(stateCost.state)))

                    if debugEnabled {
                        debugPrint("Evaluated neighbor: \(stateCost.state). Cost: \(stateCost.cost). Queued for further evaluation.")
                    }

                } else if debugEnabled {
                    debugPrint("Evaluated neighbor: \(stateCost.state). Cost: \(stateCost.cost). Cost too high, discarded.")
                }
            }
        }

        return nil
    }
}

// MARK: - Manhattan AStar
public extension AStarPathfinder where State == Coordinate, Cost == Int {

    func shortestManhattanCost(from initialState: State, toPossibleTargets targetStates: [State]) -> Cost? {
        return shortestManhattanPath(from: initialState, toPossibleTargets: targetStates)?.overallCost
    }

    func shortestManhattanPath(from initialState: State, toPossibleTargets targetStates: [State]) -> Path? {
        return shortestPath(from: initialState, toPossibleTargets: targetStates) { state in
            return targetStates.map { state.manhattanDistance(to: $0) }.min() ?? 1
        }
    }
}

// MARK: - Preset
public extension AStarPathfinder where Cost == Int {

    static func distances(_ nextStates: @escaping (State) -> [StateCost]) -> AStarPathfinder<State, Int> {
        return .init(nextStates: nextStates)
    }
}
