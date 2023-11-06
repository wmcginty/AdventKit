//
//  Measure.swift
//  
//
//  Created by Will McGinty on 12/19/22.
//

import Foundation
import OSLog

public enum Part {
    case one, two

    // MARK: - Interface
    var title: String {
        switch self {
        case .one: return "Part 1"
        case .two: return "Part 2"
        }
    }
}

private extension Logger {
    private static var subsystem = "com.wmcginty.adventkit"
    static let measurements = Logger(subsystem: subsystem, category: "measurements")
}

public func measure(part: Part, _ closure: @escaping () throws -> Void) rethrows {
    let start = Date()

    Logger.measurements.log(level: .default, "Starting \(part.title)")
    try closure()

    let end = Date()
    Logger.measurements.log(level: .default, "Finished \(part.title). Elapsed: \(end.timeIntervalSince(start))")
}