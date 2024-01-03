//
//  GraphTests.swift
//
//
//  Created by Will McGinty on 1/2/24.
//

import XCTest
@testable import AdventKit

final class GraphTests: XCTestCase {

    private var simpleGraph: UnweightedGraph = {
        let cityGraph = UnweightedGraph<String>()
        cityGraph.addEdge(.undirected, from: "Seattle", to: "Chicago")
        cityGraph.addEdge(.undirected, from: "Seattle", to: "Chicago")
        cityGraph.addEdge(.undirected, from: "Seattle", to: "Denver")
        cityGraph.addEdge(.undirected, from: "Seattle", to: "San Francisco")
        cityGraph.addEdge(.undirected, from: "San Francisco", to: "Denver")
        cityGraph.addEdge(.undirected, from: "San Francisco", to: "Los Angeles")
        cityGraph.addEdge(.undirected, from: "Los Angeles", to: "Denver")
        cityGraph.addEdge(.undirected, from: "Los Angeles", to: "Kansas City")
        cityGraph.addEdge(.undirected, from: "Los Angeles", to: "Dallas")
        cityGraph.addEdge(.undirected, from: "Denver", to: "Chicago")
        cityGraph.addEdge(.undirected, from: "Denver", to: "Kansas City")
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "Chicago")
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "New York")
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "Atlanta")
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "Dallas")
        cityGraph.addEdge(.undirected, from: "Chicago", to: "Boston")
        cityGraph.addEdge(.undirected, from: "Chicago", to: "New York")
        cityGraph.addEdge(.undirected, from: "Boston", to: "New York")
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "New York")
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "Dallas")
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "Houston")
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "Miami")
        cityGraph.addEdge(.undirected, from: "Houston", to: "Miami")
        cityGraph.addEdge(.undirected, from: "Houston", to: "Dallas")
        return cityGraph
    }()

    private var simpleWeightedGraph: WeightedGraph = {
        let cityGraph = WeightedGraph<String, Int>()
        cityGraph.addEdge(.undirected, from: "Seattle", to: "Chicago", weight: 2097)
        cityGraph.addEdge(.undirected, from: "Seattle", to: "Chicago", weight: 2097)
        cityGraph.addEdge(.undirected, from: "Seattle", to: "Denver", weight: 1331)
        cityGraph.addEdge(.undirected, from: "Seattle", to: "San Francisco", weight: 807)
        cityGraph.addEdge(.undirected, from: "San Francisco", to: "Denver", weight: 1267)
        cityGraph.addEdge(.undirected, from: "San Francisco", to: "Los Angeles", weight: 381)
        cityGraph.addEdge(.undirected, from: "Los Angeles", to: "Denver", weight: 1015)
        cityGraph.addEdge(.undirected, from: "Los Angeles", to: "Kansas City", weight: 1663)
        cityGraph.addEdge(.undirected, from: "Los Angeles", to: "Dallas", weight: 1435)
        cityGraph.addEdge(.undirected, from: "Denver", to: "Chicago", weight: 1003)
        cityGraph.addEdge(.undirected, from: "Denver", to: "Kansas City", weight: 599)
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "Chicago", weight: 533)
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "New York", weight: 1260)
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "Atlanta", weight: 864)
        cityGraph.addEdge(.undirected, from: "Kansas City", to: "Dallas", weight: 496)
        cityGraph.addEdge(.undirected, from: "Chicago", to: "Boston", weight: 983)
        cityGraph.addEdge(.undirected, from: "Chicago", to: "New York", weight: 787)
        cityGraph.addEdge(.undirected, from: "Boston", to: "New York", weight: 214)
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "New York", weight: 888)
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "Dallas", weight: 781)
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "Houston", weight: 810)
        cityGraph.addEdge(.undirected, from: "Atlanta", to: "Miami", weight: 661)
        cityGraph.addEdge(.undirected, from: "Houston", to: "Miami", weight: 1187)
        cityGraph.addEdge(.undirected, from: "Houston", to: "Dallas", weight: 239)
        return cityGraph
    }()

    func testGraphDepthFirstTraversal() {
        let graph = simpleGraph
        var results: [String] = []
        graph.depthFirstTraversal(from: "New York") { results.append($0) }

        print(graph.description)
        XCTAssertEqual("New York, Atlanta, Miami, Houston, Dallas, Kansas City, Chicago, Boston, Denver, Los Angeles, San Francisco, and Seattle", results.formatted())
    }

    func testWeightedGraphDepthFirstTraversal() {
        let graph = simpleWeightedGraph
        var results: [String] = []
        graph.depthFirstTraversal(from: "New York") { results.append($0) }

        XCTAssertEqual("New York, Atlanta, Miami, Houston, Dallas, Kansas City, Chicago, Boston, Denver, Los Angeles, San Francisco, and Seattle", results.formatted())
    }

    func testGraphBreadthFirstTraversal() {
        let graph = simpleGraph
        var results: [String] = []
        graph.breadthFirstTraversal(from: "New York") { results.append($0) }

        XCTAssertEqual("New York, Kansas City, Chicago, Boston, Atlanta, Los Angeles, Denver, Dallas, Seattle, Houston, Miami, and San Francisco", results.formatted())
    }

    func testWeightedGraphBreadthFirstTraversal() {
        let graph = simpleWeightedGraph
        var results: [String] = []
        graph.breadthFirstTraversal(from: "New York") { results.append($0) }

        XCTAssertEqual("New York, Kansas City, Chicago, Boston, Atlanta, Los Angeles, Denver, Dallas, Seattle, Houston, Miami, and San Francisco", results.formatted())
    }
}


