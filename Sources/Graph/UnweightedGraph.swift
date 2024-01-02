//
//  File.swift
//  
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public class UnweightedGraph<Element: Hashable> {

    // MARK: - Properties
    private var adjacencyList: [Vertex<Element>: [Edge<Element>]] = [:]

    // MARK: - Initializers
    public init() { /* No op */ }

    // MARK: - Interface
    public func edges(from source: Vertex<Element>) -> [Edge<Element>]? {
        return adjacencyList[source]
    }

    public func createVertex(for element: Element) -> Vertex<Element> {
        let vertex = Vertex(value: element)
        if adjacencyList[vertex] == nil {
            adjacencyList[vertex] = []
        }

        return vertex
    }

    public func addEdge(_ kind: Edge<Element>.Kind, from source: Vertex<Element>, to destination: Vertex<Element>) {
        switch kind {
        case .directed: addDirectedEdge(from: source, to: destination)
        case .undirected: addUndirectedEdge(from: source, to: destination)
        }
    }
}

// MARK: - CustomStringConvertible
extension UnweightedGraph: CustomStringConvertible where Element: CustomStringConvertible {

    public var description: String {
        var result = ""
        for (vertex, edges) in adjacencyList {
            let edgeString = edges.map(\.destination.value.description).formatted()
            result.append("\(vertex) --> [ \(edgeString) ]\n")
        }
        return result
    }
}

// MARK: - Helper
private extension UnweightedGraph {

    func addUndirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>) {
        addDirectedEdge(from: source, to: destination)
        addDirectedEdge(from: destination, to: source)
    }

    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>) {
        let edge = Edge(source: source, destination: destination, weight: nil)
        adjacencyList[source]?.append(edge)
    }
}
