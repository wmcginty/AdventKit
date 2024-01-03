//
//  Edge.swift
//  
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public protocol Edge<Element> {
    associatedtype Element: Graphable

    var source: Vertex<Element> { get }
    var destination: Vertex<Element> { get }
}

public struct UnweightedEdge<Element: Graphable>: Edge, Hashable {

    // MARK: - UnweightedEdge.Kind
    public enum Kind: CaseIterable {
        case directed, undirected
    }

    // MARK: - Properties
    public var source: Vertex<Element>
    public var destination: Vertex<Element>

    // MARK: - Initializer
    public init(source: Vertex<Element>, destination: Vertex<Element>) {
        self.source = source
        self.destination = destination
    }

    // MARK: - Interface
    var reversed: Self {
        return .init(source: destination, destination: source)
    }
}

public struct WeightedEdge<Element: Graphable, Weight: Comparable & Hashable & Numeric>: Edge, Hashable {

    public typealias Kind = UnweightedEdge<Element>.Kind

    // MARK: - Properties
    public var source: Vertex<Element>
    public var destination: Vertex<Element>
    public var weight: Weight

    // MARK: - Initializer
    public init(source: Vertex<Element>, destination: Vertex<Element>, weight: Weight) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }

}
