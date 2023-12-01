//
//  Array+Utility.swift
//
//
//  Created by Will McGinty on 12/1/23.
//

import Foundation

public extension Array {
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Self {
        return sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}
