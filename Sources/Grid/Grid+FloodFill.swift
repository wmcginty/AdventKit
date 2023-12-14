//
//  Grid+FloodFill.swift
//  
//
//  Created by Will McGinty on 12/10/23.
//

import Foundation
import DequeModule

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
    
    mutating func floodFill(with element: Element, startingAt start: Coordinate,
                            validNeighborDirections: [Coordinate.Direction] = .cardinal,
                            canFloodEvaluator: (_ from: LocatedElement, _ to: LocatedElement) -> Bool) {
        floodFill(with: { _ in element }, startingAt: start,
                  validNeighborDirections: validNeighborDirections, canFloodEvaluator: canFloodEvaluator)
    }
    
    mutating func floodFill(with transform: (Element) -> Element, startingAt start: Coordinate,
                            validNeighborDirections: [Coordinate.Direction] = .cardinal,
                            canFloodEvaluator: (_ from: LocatedElement, _ to: LocatedElement) -> Bool) {

        var deque: Deque<Coordinate> = [start]
        while let next = deque.popFirst() {
            let currentElement = self[next]
            let newElement = transform(currentElement)
            self[next] = newElement

            let neighbors = next.neighbors(in: validNeighborDirections).filter {
                guard let toElement = dictionary[$0] else { return false } // This must be a valid coordinate in the grid

                let from = LocatedElement(coordinate: next, element: newElement)
                let to = LocatedElement(coordinate: $0, element: toElement)
                return canFloodEvaluator(from, to) // We must be able to flood from `next` to `$0`
            }

            deque.append(contentsOf: neighbors)
        }
    }
    
    func floodFilled(with element: Element, startingAt start: Coordinate,
                            validNeighborDirections: [Coordinate.Direction] = .cardinal,
                            canFloodEvaluator: (_ from: LocatedElement, _ to: LocatedElement) -> Bool) -> Grid<Element> {
        var copy = self
        copy.floodFill(with: element, startingAt: start,
                       validNeighborDirections: validNeighborDirections, canFloodEvaluator: canFloodEvaluator)
        
        return copy
    }
    
    func floodFilled(startingAt start: Coordinate,
                     validNeighborDirections: [Coordinate.Direction] = .cardinal,
                     canFloodEvaluator: (_ from: LocatedElement, _ to: LocatedElement) -> Bool) -> Grid<FloodResult<Element>> {
        var resultGrid = map { FloodResult.unfilled($0) }
        var visitedCoordinates: Set<Coordinate> = []
        resultGrid.floodFill(with: { $0.filled }, startingAt: start,
                             validNeighborDirections: validNeighborDirections) { from, to in
            guard !visitedCoordinates.contains(to.coordinate) else { return false }
            
            let from = LocatedElement(coordinate: from.coordinate, element: from.element.value)
            let to = LocatedElement(coordinate: to.coordinate, element: to.element.value)
            
            guard canFloodEvaluator(from, to) else { return false }
            visitedCoordinates.insert(to.coordinate)
            return true
        }

        return resultGrid
    }
}
