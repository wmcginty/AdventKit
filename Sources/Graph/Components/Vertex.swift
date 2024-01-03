//
//  Vertex.swift
//  
//
//  Created by Will McGinty on 1/2/24.
//

import Foundation

public struct Vertex<Element: Hashable>: Hashable {

    // MARK: - Properties
    public let value: Element

    // MARK: - Initializer
    public init(value: Element) {
        self.value = value
    }
}

// MARK: - Vertex + CustomStringConvertible
extension Vertex: CustomStringConvertible where Element: CustomStringConvertible {

    public var description: String {
        return value.description
    }
}
