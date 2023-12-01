//
//  String+Utility.swift
//  
//
//  Created by Will McGinty on 12/1/23.
//

import Foundation

public extension String {
    
    func lines() -> [String] {
        components(separatedBy: .newlines)
    }
}
