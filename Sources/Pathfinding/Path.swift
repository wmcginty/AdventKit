//
//  Path.swift
//  
//
//  Created by Will McGinty on 12/18/23.
//

import Foundation

public extension DijkstraPathfinder {
    
    struct StateCost {

        // MARK: - Properties
        public let state: State
        public let cost: Cost
        
        // MARK: - Initializer
        public init(state: State, cost: Cost) {
            self.state = state
            self.cost = cost
        }
    }

    struct Path {

        // MARK: - Properties
        public let stateCosts: [StateCost]

        // MARK: - Interface
        public var states: [State] { return stateCosts.map(\.state) }
        public var overallCost: Cost { return stateCosts.last?.cost ?? 0 }
    }
}

// MARK: - Path Visualizing
public extension Grid where Element: CustomStringConvertible {

    func description<S, C>(of path: DijkstraPathfinder<S, C>.Path?, displayedWith symbol: String, convertedBy converter: (S) -> Coordinate) -> String {
        return description { coordinate, element in
            let pathCoords = path?.states.map(converter)
            return pathCoords?.contains(coordinate) == true ? symbol : nil
        }
    }

    func description<C>(of path: DijkstraPathfinder<Coordinate, C>.Path?, displayedWith symbol: String) -> String {
        return description { coordinate, element in
            let pathCoords = path?.states
            return pathCoords?.contains(coordinate) == true ? symbol : nil
        }
    }
}

