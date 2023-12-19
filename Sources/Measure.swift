//
//  Measure.swift
//  
//
//  Created by Will McGinty on 12/19/22.
//

import Foundation
@_exported import os
@_exported import OSLog
@_exported import Collections

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

public func measure<T: CustomStringConvertible>(part: Part, _ closure: @escaping () throws -> T) rethrows {
    let start = Date()
    let logger = Logger.measurements

    logger.critical("Starting \(part.title)...")
    let answer = try closure()
    let end = Date()
    let elapsed: Duration = .milliseconds(end.timeIntervalSince(start) * 1000)
    let formatStyle = Duration.UnitsFormatStyle(allowedUnits: [.nanoseconds, .microseconds, .milliseconds, .seconds, .minutes],
                                                width: .narrow, maximumUnitCount: 1, fractionalPart: .show(length: 3))
    logger.critical("Finished \(part.title) [\(elapsed.formatted(formatStyle))]. Answer: \(answer)")
}

public func measure<T: CustomStringConvertible>(part: Part, _ closure: @escaping (Logger) throws -> T) rethrows {
    let start = Date()
    let logger = Logger.measurements

    logger.critical("Starting \(part.title)...")
    let answer = try closure(logger)
    let end = Date()
    let elapsed: Duration = .milliseconds(end.timeIntervalSince(start) * 1000)
    let formatStyle = Duration.UnitsFormatStyle(allowedUnits: [.nanoseconds, .microseconds, .milliseconds, .seconds, .minutes],
                                                width: .narrow, maximumUnitCount: 1, fractionalPart: .show(length: 3))
    logger.critical("Finished \(part.title) [\(elapsed.formatted(formatStyle))]. Answer: \(answer)")
}

public func measure(part: Part, _ closure: @escaping (Logger) throws -> Void) rethrows {
    let start = Date()
    let logger = Logger.measurements

    logger.critical("Starting \(part.title)...")
    try closure(logger)
    let end = Date()
    let elapsed: Duration = .milliseconds(end.timeIntervalSince(start) * 1000)
    let formatStyle = Duration.UnitsFormatStyle(allowedUnits: [.nanoseconds, .microseconds, .milliseconds, .seconds, .minutes],
                                                width: .narrow, maximumUnitCount: 1, fractionalPart: .show(length: 3))
    logger.critical("Finished \(part.title) [\(elapsed.formatted(formatStyle))].")
}
