import XCTest
@testable import AdventKit

final class AdventKitTests: XCTestCase {
    
    enum Content: String, CaseIterable, CustomStringConvertible {
        case path = "⬜️", wall = "⬛️", water = "🟦"
        
        var description: String { return rawValue }
    }
    
    func testFloodFill_cardinalDirections() throws {
        let grid = Grid<Content>(contents:
                                    [[.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .wall, .path, .path, .path, .path],
                                     [.wall, .wall, .path, .path, .path, .wall, .wall],
                                     [.path, .path, .path, .path, .wall, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path]])
        
        let flooded = grid.floodFilled(with: .water, startingAt: .init(x: 3, y: 3),
                                       canFloodEvaluator: { $1.element == .path })
        
        let expectation = """
⬜️⬜️⬜️⬛️🟦🟦🟦
⬜️⬜️⬜️⬛️🟦🟦🟦
⬜️⬜️⬛️🟦🟦🟦🟦
⬛️⬛️🟦🟦🟦⬛️⬛️
🟦🟦🟦🟦⬛️⬜️⬜️
🟦🟦🟦⬛️⬜️⬜️⬜️
🟦🟦🟦⬛️⬜️⬜️⬜️
"""
        
        XCTAssertEqual(flooded.description, expectation)
    }
    
    func testFloodFill_allDirections() throws {
        let grid = Grid<Content>(contents:
                                    [[.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .wall, .path, .path, .path, .path],
                                     [.wall, .wall, .path, .path, .path, .wall, .wall],
                                     [.path, .path, .path, .path, .wall, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path]])
        
        let flooded = grid.floodFilled(with: .water, startingAt: .init(x: 3, y: 3),
                                       validNeighborDirections: Coordinate.Direction.allCases,
                                       canFloodEvaluator: { $1.element == .path })
        
        let expectation = """
🟦🟦🟦⬛️🟦🟦🟦
🟦🟦🟦⬛️🟦🟦🟦
🟦🟦⬛️🟦🟦🟦🟦
⬛️⬛️🟦🟦🟦⬛️⬛️
🟦🟦🟦🟦⬛️🟦🟦
🟦🟦🟦⬛️🟦🟦🟦
🟦🟦🟦⬛️🟦🟦🟦
"""
        
        XCTAssertEqual(flooded.description, expectation)
    }
    
    func testFloodFill_returningFloodResults() throws {
        let grid = Grid<Content>(contents:
                                    [[.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .wall, .path, .path, .path, .path],
                                     [.wall, .wall, .path, .path, .path, .wall, .wall],
                                     [.path, .path, .path, .path, .wall, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path],
                                     [.path, .path, .path, .wall, .path, .path, .path]])
        
        let flooded = grid.floodFilled(startingAt: .init(x: 3, y: 3),
                                       canFloodEvaluator: { $1.element == .path })
        
        let description = flooded.description { coordinate, content in
            if content.isFilled {
                return "🟧"
            }
            
            return nil
        }
                                              
        let expectation = """
⬜️⬜️⬜️⬛️🟧🟧🟧
⬜️⬜️⬜️⬛️🟧🟧🟧
⬜️⬜️⬛️🟧🟧🟧🟧
⬛️⬛️🟧🟧🟧⬛️⬛️
🟧🟧🟧🟧⬛️⬜️⬜️
🟧🟧🟧⬛️⬜️⬜️⬜️
🟧🟧🟧⬛️⬜️⬜️⬜️
"""
        XCTAssertEqual(description, expectation)
    }
    
    func testCoordinateDirections() {
        let coordinate = Coordinate(x: 3, y: 3)
        for dir in Coordinate.Direction.allCases {
            let neighbor = coordinate.neighbor(in: dir)
            let calculatedDir = Coordinate.Direction(from: coordinate, toNeighbor: neighbor)
            let otherCalculatedDir = coordinate.direction(to: neighbor)
            
            XCTAssertEqual(calculatedDir, dir)
            XCTAssertEqual(otherCalculatedDir, dir)
        }
    }
}
