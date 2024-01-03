//
//  Graph.swift
//
//
//  Created by Will McGinty on 1/3/24.
//

import Foundation

public protocol Graphable: Hashable {
    func combined(with other: Self) -> Self
}

public protocol Graph<Element> {
    associatedtype Element: Graphable
    associatedtype EdgeType: Edge where EdgeType.Element == Element

    func vertex(for element: Element) -> Vertex<Element>
    func edges(from vertex: Vertex<Element>) -> [EdgeType]?
}

// MARK: - Traversal
public extension Graph {

    func depthFirstTraversal(from source: Element, visit: (Element) -> Void) {
        return depthFirstTraversal(from: vertex(for: source), visit: { visit($0.value) })
    }

    func depthFirstTraversal(from source: Vertex<Element>, visit: (Vertex<Element>) -> Void) {
        var visited: Set<Vertex<Element>> = []
        var deque: Deque<Vertex<Element>> = [source]
        while let next = deque.popLast() {
            if visited.contains(next) {
                continue
            }
            visited.insert(next)
            visit(next)

            if let neighbors = edges(from: next)?.map(\.destination) {
                deque.append(contentsOf: neighbors)
            }
        }
    }

    func breadthFirstTraversal(from source: Element, visit: (Element) -> Void) {
        return breadthFirstTraversal(from: vertex(for: source), visit: { visit($0.value) })
    }

    func breadthFirstTraversal(from source: Vertex<Element>, visit: (Vertex<Element>) -> Void) {
        var visited: Set<Vertex<Element>> = []
        var deque: Deque<Vertex<Element>> = [source]
        while let next = deque.popFirst() {
            if visited.contains(next) {
                continue
            }
            visited.insert(next)
            visit(next)

            if let neighbors = edges(from: next)?.map(\.destination) {
                deque.append(contentsOf: neighbors)
            }
        }
    }
}

// MARK: - Graphable Conformances
extension String: Graphable {
    public func combined(with other: String) -> String { [self, other].joined(separator: "-") }
}

