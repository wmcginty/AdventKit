//
//  Vertex.swift
//  
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public struct Vertex<Element: Graphable>: Hashable {

    // MARK: - Properties
    public var value: Element

    // MARK: - Initializer
    public init(value: Element) {
        self.value = value
    }

    // MARK: - Interface
    public func combined(with other: Vertex<Element>) -> Vertex<Element> {
        return Vertex(value: value.combined(with: other.value))
    }
}

// MARK: - Vertex + CustomStringConvertible
extension Vertex: CustomStringConvertible where Element: CustomStringConvertible {

    public var description: String {
        return value.description
    }
}
