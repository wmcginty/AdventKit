//
//  WeightedGraph.swift
//
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public class WeightedGraph<Element: Hashable> {

    // MARK: - Properties
    private var adjacencyList: [Vertex<Element>: [Edge<Element>]] = [:]

    // MARK: - Initializers
    public init() { /* No op */ }

    // MARK: - Interface
    public func edges(from source: Vertex<Element>) -> [Edge<Element>]? {
        return adjacencyList[source]
    }

    /// Note: This will only return a defined edge, it will not traverse the graph
    public func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double? {
        guard let edges = adjacencyList[source] else { return nil }
        return edges.first { $0.destination == destination}?.weight
    }

    public func createVertex(for element: Element) -> Vertex<Element> {
        let vertex = Vertex(value: element)
        if adjacencyList[vertex] == nil {
            adjacencyList[vertex] = []
        }

        return vertex
    }

    public func addEdge(_ kind: Edge<Element>.Kind, from source: Element, to destination: Element, weight: Double) {
        let sourceVertex = createVertex(for: source)
        let destinationVertex = createVertex(for: destination)

        addEdge(kind, from: sourceVertex, to: destinationVertex, weight: weight)
    }

    public func addEdge(_ kind: Edge<Element>.Kind, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double) {
        switch kind {
        case .directed: addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected: addUndirectedEdge(from: source, to: destination, weight: weight)
        }
    }
}

// MARK: - CustomStringConvertible
extension WeightedGraph: CustomStringConvertible where Element: CustomStringConvertible {

    public var description: String {
        var result = ""
        for (vertex, edges) in adjacencyList {
            let edgeString = edges.map { "\($0.destination.value) (\($0.weight!))" }.formatted()
            result.append("\(vertex) --> [ \(edgeString) ]\n")
        }
        return result
    }
}

// MARK: - Helper
private extension WeightedGraph {

    func addUndirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }

    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencyList[source]?.append(edge)
    }
}
