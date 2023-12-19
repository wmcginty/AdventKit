//
//  DijkstraPathfinder.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import Foundation

public struct DijkstraPathfinder<State: Hashable, Cost: Numeric & Comparable> {

    private final class PathNode: Comparable, CustomStringConvertible {

        // MARK: - Coordinates
        let state: State
        let parent: PathNode?
        let cost: Cost // Cost of traveling to this node

        // MARK: - Initializer
        init(state: State, parent: PathNode? = nil, cost: Cost) {
            self.state = state
            self.parent = parent
            self.cost = (parent?.cost ?? 0) + cost
        }

        // MARK: - Interface
        var fullPath: Path {
            var result: [PathNode] = []
            var node: PathNode? = self
            while let n = node {
                result.append(n)
                node = n.parent
            }

            return Path(stateCosts: result.reversed().map { .init(state: $0.state, cost: $0.cost) })
        }

        // MARK: - Equatable
        static func == (lhs: PathNode, rhs: PathNode) -> Bool {
            lhs.state == rhs.state
        }

        // MARK: - Comparable
        static func < (lhs: PathNode, rhs: PathNode) -> Bool {
            lhs.cost < rhs.cost
        }

        // MARK: - CustomStringConvertible
        var description: String {
            "state=\(state) cost=\(cost)"
        }
    }

    // MARK: - Properties
    public let nextStateGenerator: (State) -> [StateCost]

    // MARK: - Initializer
    public init(nextStates: @escaping (State) -> [StateCost]) {
        self.nextStateGenerator = nextStates
    }

    // MARK: - Interface
    public func shortestCost(from initialState: State, toTargets targetStates: [State]) -> Cost? {
        return shortestPath(from: initialState, toTargets: targetStates)?.overallCost
    }

    public func shortestCost(from initialState: State, toTarget targetPredicate: (State) -> Bool) -> Cost? {
        return shortestPath(from: initialState, toTarget: targetPredicate)?.overallCost
    }

    public func shortestPath(from initialState: State, toTargets targetStates: [State]) -> Path? {
        return shortestPath(from: initialState, toTarget: { targetStates.contains($0) })
    }

    public func shortestPath(from initialState: State, toTarget targetPredicate: (State) -> Bool) -> Path? {
        var visited: Set<State> = []
        var priorityQueue = Heap<PathNode>([.init(state: initialState, parent: nil, cost: 0)])

        while let next = priorityQueue.popMin() {
            if visited.contains(next.state) {
                continue  // We already have a distance for this state, we can skip re-computation
            }
            visited.insert(next.state)

            if targetPredicate(next.state) {
                return next.fullPath
            }

            for stateCost in nextStateGenerator(next.state) {
                assert(stateCost.cost >= 0, "Negative costs are disallowed.")
                priorityQueue.insert(.init(state: stateCost.state, parent: next, cost: stateCost.cost))
            }
        }

        return nil
    }
}

// MARK: - Preset
public extension DijkstraPathfinder where Cost == Int {

    static func distances(_ nextStates: @escaping (State) -> [StateCost]) -> DijkstraPathfinder<State, Int> {
        return .init(nextStates: nextStates)
    }
}

