//
//  Grid.Sparse.swift
//
//
//  Created by Will McGinty on 12/18/23.
//

import Foundation

public extension Grid {

    struct Sparse {

        // MARK: - Properties
        public let coordinates: Set<Coordinate>
        private let content: (Set<Coordinate>, Coordinate) -> Element
        public let minX: Int
        public let minY: Int
        public let maxX: Int
        public let maxY: Int

        // MARK: - Initializer
        public init<C: Collection>(coordinates: C, outerPadding: Int = 0, content: @escaping (Set<Coordinate>, Coordinate) -> Element) where C.Element == Coordinate {
            assert(!coordinates.isEmpty)

            self.coordinates = Set(coordinates)
            self.content = content
            let (minimumX, maximumX) = coordinates.map(\.x).minAndMax()!
            let (minimumY, maximumY) = coordinates.map(\.y).minAndMax()!

            self.minX = minimumX - outerPadding
            self.minY = minimumY - outerPadding
            self.maxX = maximumX + outerPadding
            self.maxY = maximumY + outerPadding
        }

        //MARK: - Interface
        public func content(at coordinate: Coordinate) -> Element {
            return content(coordinates, coordinate)
        }

        public func denseGrid() -> Grid<Element> {
            var elements: [[Element]] = []

            for y in minY...maxY {
                var row: [Element] = []
                for x in minX...maxX {
                    let coordinate = Coordinate(x: x, y: y)
                    row.append(content(at: coordinate))
                }
                elements.append(row)
            }

            return Grid(contents: elements)
        }
    }
}
