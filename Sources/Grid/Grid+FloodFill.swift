//
//  Grid+FloodFill.swift
//  
//
//  Created by Will McGinty on 12/10/23.
//

import Foundation

public enum FloodResult<T> {
    case filled(T)
    case unfilled(T)
    
    // MARK: - Interface
    public var isFilled: Bool {
        switch self {
        case .filled: return true
        case .unfilled: return false
        }
    }
    
    public var filled: FloodResult {
        switch self {
        case .filled(let value), .unfilled(let value): return .filled(value)
        }
    }
    
    public var value: T {
        switch self {
        case .filled(let value), .unfilled(let value): return value
        }
    }
}

// MARK: - FloodResult + CustomStringConvertible
extension FloodResult: CustomStringConvertible where T: CustomStringConvertible {
    public var description: String { return value.description }
}

public extension Grid {
    
    struct LocatedElement<T> {
        
        // MARK: - Properties
        public let coordinate: Coordinate
        public let element: T
    }
    
    mutating func floodFill(with element: Element, startingAt start: Coordinate,
                            validNeighborDirections: [Coordinate.Direction] = .cardinal,
                            canFloodEvaluator: (_ from: LocatedElement<Element>, _ to: LocatedElement<Element>) -> Bool) {
        floodFill(with: { _ in element }, startingAt: start,
                  validNeighborDirections: validNeighborDirections, canFloodEvaluator: canFloodEvaluator)
    }
    
    mutating func floodFill(with transform: (Element) -> Element, startingAt start: Coordinate,
                            validNeighborDirections: [Coordinate.Direction] = .cardinal,
                            canFloodEvaluator: (_ from: LocatedElement<Element>, _ to: LocatedElement<Element>) -> Bool) {
        let currentElement = self[start]
        let newElement = transform(currentElement)
        self[start] = newElement

        let neighbors = start.neighbors(in: validNeighborDirections)
            .filter {
                guard let toElement = dictionary[$0] else { return false } // This must be a valid coordinate in the grid
                
                let from = LocatedElement(coordinate: start, element: newElement)
                let to = LocatedElement(coordinate: $0, element: toElement)
                return canFloodEvaluator(from, to) // We must be able to flood from `start` to `$0`
            }

        neighbors.forEach {
            floodFill(with: transform, startingAt: $0,
                      validNeighborDirections: validNeighborDirections, canFloodEvaluator: canFloodEvaluator)
        }
    }
    
    func floodFilled(with element: Element, startingAt start: Coordinate,
                            validNeighborDirections: [Coordinate.Direction] = .cardinal,
                            canFloodEvaluator: (_ from: LocatedElement<Element>, _ to: LocatedElement<Element>) -> Bool) -> Grid<Element> {
        var copy = self
        copy.floodFill(with: element, startingAt: start,
                       validNeighborDirections: validNeighborDirections, canFloodEvaluator: canFloodEvaluator)
        
        return copy
    }
    
    func floodFilled(startingAt start: Coordinate,
                     validNeighborDirections: [Coordinate.Direction] = .cardinal,
                     canFloodEvaluator: (_ from: LocatedElement<Element>, _ to: LocatedElement<Element>) -> Bool) -> Grid<FloodResult<Element>> {
        var resultGrid = map { FloodResult.unfilled($0) }
        var visitedCoordinates: Set<Coordinate> = []
        resultGrid.floodFill(with: { $0.filled }, startingAt: start,
                             validNeighborDirections: validNeighborDirections) { from, to in
            guard !visitedCoordinates.contains(to.coordinate) else { return false }
            visitedCoordinates.insert(to.coordinate)
            
            let from = LocatedElement<Element>(coordinate: from.coordinate, element: from.element.value)
            let to = LocatedElement<Element>(coordinate: to.coordinate, element: to.element.value)
            return canFloodEvaluator(from, to)
        }

        return resultGrid
    }
}
