//
//  Edge.swift
//  
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public struct Edge<Element: Hashable>: Hashable {
    
    // MARK: - Edge.Kind
    public enum Kind: CaseIterable {
        case directed, undirected
    }
    
    // MARK: - Edge.Weighted
    public struct Weighted<Weight: Comparable & Hashable & Numeric>: Hashable {

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

    // MARK: - Properties
    public var source: Vertex<Element>
    public var destination: Vertex<Element>
    
    // MARK: - Initializer
    public init(source: Vertex<Element>, destination: Vertex<Element>) {
        self.source = source
        self.destination = destination
    }
}

