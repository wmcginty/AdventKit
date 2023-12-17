//
//  AStarPathfinder.swift
//
//
//  Created by Will McGinty on 12/20/22.
//

import Foundation
import Collections

public protocol Pathfindable {
    func neighbors(for coordinate: Coordinate, moving direction: Coordinate.Direction?) -> Set<Coordinate>
    func costToMove(from: Coordinate, to: Coordinate) -> Int
    func distance(from: Coordinate, to: Coordinate) -> Int
}

public extension Pathfindable {
    
    func costToMove(from: Coordinate, to: Coordinate) -> Int {
        return 1
    }
    
    func distance(from: Coordinate, to: Coordinate) -> Int {
        return from.manhattanDistance(to: to)
    }
}

public class AStarPathfinder<Map: Pathfindable> {

    private final class PathNode: Comparable, CustomStringConvertible {

        // MARK: - Coordinates
        let coordinate: Coordinate
        let parent: PathNode?

        let gScore: Int // Distance from start to node
        let hScore: Int // Heuristic distance from node to destination (using Manhattan distance)
        var fScore: Int { gScore + hScore }

        // MARK: - Initializer
        init(coordinate: Coordinate, parent: PathNode? = nil, moveCost: Int = 0, hScore: Int = 0) {
            self.coordinate = coordinate
            self.parent = parent
            self.gScore = (parent?.gScore ?? 0) + moveCost
            self.hScore = hScore
        }

        static func == (lhs: PathNode, rhs: PathNode) -> Bool {
            lhs.coordinate == rhs.coordinate
        }

        static func < (lhs: PathNode, rhs: PathNode) -> Bool {
            lhs.fScore < rhs.fScore
        }

        // MARK: - CustomStringConvertible
        var description: String {
            "pos=\(coordinate) g=\(gScore) h=\(hScore) f=\(fScore)"
        }
    }

    // MARK: - Properties
    public let map: Map
    public var debugEnabled: Bool = false

    // MARK: - Initializer
    public init(map: Map) {
        self.map = map
    }

    // MARK: - Interface
    public func shortestPath(from start: Coordinate, to end: Coordinate) -> [Coordinate]? {
        return shortestPath(from: start, to: [end])
    }

    public func shortestPath(from start: Coordinate, to ends: [Coordinate]) -> [Coordinate]? {
        var frontier = Heap<PathNode>()
        frontier.insert(PathNode(coordinate: start))

        var explored = [Coordinate: Int]()
        explored[start] = 0

        while let currentNode = frontier.popMin() {
            let currentCoordinate = currentNode.coordinate
            let currentDirection = currentNode.parent?.coordinate.direction(to: currentCoordinate)
            
            if debugEnabled {
                print("Current: \(currentCoordinate)")
                print("Previous: \(String(describing: currentNode.parent?.coordinate))")
                print("Direction: \(String(describing: currentDirection))")
            }

            if ends.contains(currentCoordinate) {
                return fullPath(from: currentNode)
            }
            
            let neighbors = map.neighbors(for: currentCoordinate, moving: currentDirection)
            
            if debugEnabled {
                print("Valid Neighbors: \(neighbors)")
                print("Full Path: \(fullPath(from: currentNode))")
            }

            for neighbor in neighbors {
                let moveCost = map.costToMove(from: currentCoordinate, to: neighbor)
                let newCost = currentNode.gScore + moveCost

                if explored[neighbor] == nil || explored[neighbor]! > newCost {
                    explored[neighbor] = newCost
                    let hScore = map.distance(from: currentCoordinate, to: neighbor)
                    let node = PathNode(coordinate: neighbor, parent: currentNode, moveCost: moveCost, hScore: hScore)
                    frontier.insert(node)
                }
            }
        }

        return nil
    }
}

// MARK: - Helper
private extension AStarPathfinder {
    
    private func fullPath(from currentNode: PathNode) -> [Coordinate] {
        var result: [Coordinate] = []
        var node: PathNode? = currentNode
        while let n = node {
            result.append(n.coordinate)
            node = n.parent
        }
        return Array(result.reversed())
    }
}
