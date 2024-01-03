//
//  Pathfinder.swift
//  
//
//  Created by Will McGinty on 1/3/24.
//

import Foundation

public enum Pathfinder {

    public struct StateCost<State: Hashable, Cost: Numeric & Comparable> {

        // MARK: - Properties
        public let state: State
        public let cost: Cost

        // MARK: - Initializer
        public init(state: State, cost: Cost) {
            self.state = state
            self.cost = cost
        }
    }

    public struct Path<State: Hashable, Cost: Numeric & Comparable> {

        public struct Node {

            // MARK: - Properties
            public let state: State
            public let incrementalCost: Cost
            public let totalCost: Cost

            // MARK: - Initializer
            public init(state: State, incrementalCost: Cost, totalCost: Cost) {
                self.state = state
                self.incrementalCost = incrementalCost
                self.totalCost = totalCost
            }
        }

        // MARK: - Properties
        public let nodes: [Node]

        // MARK: - Interface
        public var states: [State] { return nodes.map(\.state) }
        public var overallCost: Cost { return nodes.last?.totalCost ?? 0 }
    }
}

// MARK: - Path Visualizing
public extension Grid where Element: CustomStringConvertible {

    func description<S, C>(of path: Pathfinder.Path<S, C>?, displayedWith symbol: String, convertedBy converter: (S) -> Coordinate) -> String {
        return description { coordinate, element in
            let pathCoords = path?.states.map(converter)
            return pathCoords?.contains(coordinate) == true ? symbol : nil
        }
    }

    func description<C>(of path: Pathfinder.Path<Coordinate, C>?, displayedWith symbol: String) -> String {
        return description { coordinate, element in
            let pathCoords = path?.states
            return pathCoords?.contains(coordinate) == true ? symbol : nil
        }
    }
}

