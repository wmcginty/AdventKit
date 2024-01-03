//
//  WeightedGraph.swift
//
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public class WeightedGraph<Element: Hashable, Weight: Comparable & Hashable & Numeric>: Graph {

    // MARK: - Properties
    private var adjacencyList: [Vertex<Element>: [WeightedEdge<Element, Weight>]] = [:]

    // MARK: - Initializers
    public init() { /* No op */ }

    // MARK: - Interface
    public func vertex(for element: Element) -> Vertex<Element> {
        let vertex = Vertex(value: element)
        if adjacencyList[vertex] == nil {
            adjacencyList[vertex] = []
        }

        return vertex
    }

    public func edges(from source: Vertex<Element>) -> [WeightedEdge<Element, Weight>]? {
        return adjacencyList[source]
    }

    /// Note: This will only return a defined edge, it will not traverse the graph
    public func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Weight? {
        guard let edges = adjacencyList[source] else { return nil }
        return edges.first { $0.destination == destination }?.weight
    }
    
    public func addEdge(_ kind: WeightedEdge<Element, Weight>.Kind, from source: Element, to destination: Element, weight: Weight) {
        let sourceVertex = vertex(for: source)
        let destinationVertex = vertex(for: destination)

        addEdge(kind, from: sourceVertex, to: destinationVertex, weight: weight)
    }

    public func addEdge(_ kind: WeightedEdge<Element, Weight>.Kind, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Weight) {
        switch kind {
        case .directed: addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected: addUndirectedEdge(from: source, to: destination, weight: weight)
        }
    }
}

// MARK: - Pathfinding
public extension WeightedGraph {
    
    func shortestPath(from source: Element, to destination: Element) -> DijkstraPathfinder<Vertex<Element>, Weight>.Path? {
        return shortestPath(from: vertex(for: source), to: vertex(for: destination))
    }
    
    func shortestPath(from source: Vertex<Element>, to destination: Vertex<Element>) -> DijkstraPathfinder<Vertex<Element>, Weight>.Path? {
        let pathfinder = DijkstraPathfinder<Vertex<Element>, Weight> { current in
            guard let neighboringEdges = self.edges(from: current) else { return [] }
            return neighboringEdges.map { .init(state: $0.destination, cost: $0.weight) }
        }
        
        return pathfinder.shortestPath(from: source, toPossibleTargets: [destination])
    }

    func shortestPath(from source: Element, to destination: (Element) -> Bool) -> DijkstraPathfinder<Vertex<Element>, Weight>.Path? {
        return shortestPath(from: vertex(for: source)) { vertex in
            return destination(vertex.value)
        }
    }

    func shortestPath(from source: Vertex<Element>, to destination: (Vertex<Element>) -> Bool) -> DijkstraPathfinder<Vertex<Element>, Weight>.Path? {
        let pathfinder = DijkstraPathfinder<Vertex<Element>, Weight> { current in
            guard let neighboringEdges = self.edges(from: current) else { return [] }
            return neighboringEdges.map { .init(state: $0.destination, cost: $0.weight) }
        }

        return pathfinder.shortestPath(from: source, toTarget: destination)
    }
}

// MARK: - CustomStringConvertible
extension WeightedGraph: CustomStringConvertible where Element: CustomStringConvertible {

    public var description: String {
        var result = ""
        for (vertex, edges) in adjacencyList {
            let edgeString = edges.map { "\($0.destination.value) (\($0.weight))" }.formatted()
            result.append("\(vertex) --> [ \(edgeString) ]\n")
        }
        return result
    }
}

// MARK: - Helper
private extension WeightedGraph {

    func addUndirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Weight) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }

    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Weight) {
        let edge = WeightedEdge(source: source, destination: destination, weight: weight)
        adjacencyList[source]?.append(edge)
    }
}
