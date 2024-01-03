//
//  UnweightedGraph.swift
//
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public class UnweightedGraph<Element: Graphable>: Graph, Equatable {

    // MARK: - Properties
    private var adjacencyList: [Vertex<Element>: [UnweightedEdge<Element>]] = [:]

    // MARK: - Initializers
    public init() { /* No op */ }

    public init(adjacencyList: [Vertex<Element>: [UnweightedEdge<Element>]]) {
        self.adjacencyList = adjacencyList
    }

    public init(unweightedGraph: UnweightedGraph<Element>) {
        self.adjacencyList = unweightedGraph.adjacencyList
    }

    // MARK: - Interface
    public var vertices: [Vertex<Element>] { return Array(adjacencyList.keys) }
    public var vertexCount: Int { return adjacencyList.keys.count }
    public var edgeCount: Int {
        var edgeCount = 0
        var seen: Set<UnweightedEdge<Element>> = []
        for edge in adjacencyList.values.flatMap({ $0 }) {
            if seen.contains(edge) {
                continue
            }

            seen.insert(edge.reversed)
            edgeCount += 1
        }

        return edgeCount
    }

    public func vertex(for element: Element) -> Vertex<Element> {
        let vertex = Vertex(value: element)
        if adjacencyList[vertex] == nil {
            adjacencyList[vertex] = []
        }

        return vertex
    }

    func remove(vertex: Vertex<Element>) {
        adjacencyList.removeValue(forKey: vertex)

        for (otherVertex, edges) in adjacencyList {
            adjacencyList[otherVertex] = edges.filter { $0.destination != vertex }
        }
    }

    public func edges(from source: Vertex<Element>) -> [UnweightedEdge<Element>]? {
        return adjacencyList[source]
    }

    public func addEdge(_ kind: UnweightedEdge<Element>.Kind, from source: Element, to destination: Element) {
        let sourceVertex = vertex(for: source)
        let destinationVertex = vertex(for: destination)

        addEdge(kind, from: sourceVertex, to: destinationVertex)
    }

    public func addEdge(_ kind: UnweightedEdge<Element>.Kind, from source: Vertex<Element>, to destination: Vertex<Element>) {
        switch kind {
        case .directed: addDirectedEdge(from: source, to: destination)
        case .undirected: addUndirectedEdge(from: source, to: destination)
        }
    }

    public func remove(edge: UnweightedEdge<Element>) {
        adjacencyList[edge.source] = adjacencyList[edge.source, default: []].filter { $0 != edge }
    }
}

// MARK: - Min Cut
extension UnweightedGraph {

    public func contract(edge: UnweightedEdge<Element>) {
        let source = edge.source
        let destination = edge.destination

        let merged = vertex(for: source.value.combined(with: destination.value))
        edges(from: source)?.forEach {
            if ![source, destination].contains($0.destination) {
                addEdge(.undirected, from: merged, to: $0.destination)
            }
        }

        edges(from: destination)?.forEach {
            if ![source, destination].contains($0.destination) {
                addEdge(.undirected, from: merged, to: $0.destination)
            }
        }

        remove(vertex: source)
        remove(vertex: destination)
    }

    private var randomEdge: UnweightedEdge<Element>? {
        let edges = adjacencyList.values.flatMap { $0 }
        return edges.randomElement()
    }

    public func kargersMinimumCut(iterations: Int) -> Int {
        var minCut = Int.max
        var minCutGraph = self

        for _ in 0..<iterations {
            // Make a copy of the graph
            let cutGraph = UnweightedGraph(unweightedGraph: self)

            // Keep contracting edges until 2 vertices are left
            while cutGraph.vertexCount > 2 {
                if let randomEdge = cutGraph.randomEdge {
                    cutGraph.contract(edge: randomEdge)
                }
            }

            // Count the edges between the remaining two vertices
            let cutSize = cutGraph.edgeCount

            if cutSize < minCut {
                minCut = cutSize
                minCutGraph = cutGraph
            }
        }

        print(minCutGraph)
        return minCut
    }
}

// MARK: - CustomStringConvertible
extension UnweightedGraph: CustomStringConvertible where Element: CustomStringConvertible {

    public var description: String {
        var result: [String] = []
        for (vertex, edges) in adjacencyList {
            let edgeString = edges.map(\.destination.value.description).sorted().formatted()
            result.append("\(vertex) --> [ \(edgeString) ]")
        }

        return result.sorted().joined(separator: "\n")
    }
}

// MARK: - Equatable
extension UnweightedGraph {

    public static func == (lhs: UnweightedGraph<Element>, rhs: UnweightedGraph<Element>) -> Bool {
        return lhs.adjacencyList == rhs.adjacencyList
    }
}

// MARK: - Helper
private extension UnweightedGraph {

    func addUndirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>) {
        addDirectedEdge(from: source, to: destination)
        addDirectedEdge(from: destination, to: source)
    }

    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>) {
        let edge = UnweightedEdge(source: source, destination: destination)
        adjacencyList[source]?.append(edge)
    }
}
