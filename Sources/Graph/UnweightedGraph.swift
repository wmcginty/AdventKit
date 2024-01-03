//
//  UnweightedGraph.swift
//
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public class UnweightedGraph<Element: Hashable>: Graph {

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

        for (vertex, edges) in adjacencyList {
            adjacencyList[vertex] = edges.filter { $0.destination != vertex }
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

    private var randomEdge: UnweightedEdge<Element>? {
        let edges = adjacencyList.values.flatMap { $0 }
        return edges.randomElement()
    }

    public func contract(edge: UnweightedEdge<Element>) {
        let sourceVertex = edge.source
        let destinationVertex = edge.destination

        let edgesFromSource = edges(from: sourceVertex) ?? []
        if let edgesFromDestination = edges(from: destinationVertex) {
            for edge in edgesFromDestination {
                if let invertedEdge = edges(from: edge.destination)?.first(where: { $0.destination == destinationVertex }) {
                    remove(edge: invertedEdge)
                    addEdge(.directed, from: invertedEdge.source, to: edge.destination)
                }

                if edge.destination != sourceVertex {
                    if !edgesFromSource.contains(where: { $0.destination == edge.destination }) {
                        addEdge(.directed, from: sourceVertex, to: edge.destination)
                    }
                }
            }
        }

        remove(vertex: destinationVertex)
    }

    public func kargersMinimumCut(iterations: Int) -> [UnweightedEdge<Element>] {
        var minCut = Int.max
        var cutEdges: [UnweightedEdge<Element>] = []

        for _ in 0..<iterations {
            // Make a copy of the graph
            let cutGraph = UnweightedGraph(unweightedGraph: self)

            // Keep contracting edges until 2 vertices are left
            while cutGraph.vertexCount > 2 {
                if let randomEdge = cutGraph.randomEdge {

                    cutGraph.contract(edge: randomEdge)
                    cutEdges.append(randomEdge)
                }
            }

            // Count the edges between the remaining two vertices
            let cutSize = cutGraph.edgeCount

            if cutSize < minCut {
                minCut = cutSize
            }
        }

        return cutEdges
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
        let edge = UnweightedEdge(source: source, destination: destination)
        adjacencyList[source]?.append(edge)
    }
}
