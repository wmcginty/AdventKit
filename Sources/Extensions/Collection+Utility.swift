//
//  Array+Utility.swift
//
//
//  Created by Will McGinty on 12/1/23.
//

import Foundation

public extension Array {
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Self {
        return self.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    func min<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        return self.min(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
    }

    func max<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        return self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
    }

    func minAndMax<T: Comparable>(by keyPath: KeyPath<Element, T>) -> (min: Element, max: Element)? {
        return self.minAndMax(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })
    }
}
