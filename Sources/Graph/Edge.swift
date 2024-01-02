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

    // MARK: - Properties
    public var source: Vertex<Element>
    public var destination: Vertex<Element>
    public var weight: Double?
}

