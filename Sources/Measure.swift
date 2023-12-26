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
    
    func formatAnswer<T: CustomStringConvertible>(_ answer: T?, for part: Part, foundAfter duration: Duration) {
        if let answer {
            critical("Finished \(part.title) [\(duration.formatElapsed())]. Answer: \(answer)")
        } else {
            critical("Finished \(part.title) [\(duration.formatElapsed())]. Answer not found.")
        }
    }
}

private extension Duration.UnitsFormatStyle {
    static let underMinute = Duration.UnitsFormatStyle(allowedUnits: [.nanoseconds, .microseconds, .milliseconds, .seconds, .minutes],
                                                       width: .narrow, maximumUnitCount: 1, fractionalPart: .show(length: 3))
    
    static let overMinute = Duration.UnitsFormatStyle(allowedUnits: [.nanoseconds, .microseconds, .milliseconds, .seconds, .minutes],
                                                      width: .narrow, maximumUnitCount: 2, fractionalPart: .show(length: 3))
}

private extension Duration {
    
    func formatElapsed() -> String {
        return self.formatted(self > .seconds(60) ? Duration.UnitsFormatStyle.overMinute : .underMinute)
    }
}

public func measure<T: CustomStringConvertible>(part: Part, _ closure: @escaping () throws -> T?) rethrows {
    let start = Date()
    let logger = Logger.measurements

    logger.critical("Starting \(part.title)...")
    let answer = try closure()
    let end = Date()
    let elapsed: Duration = .milliseconds(end.timeIntervalSince(start) * 1000)
    logger.formatAnswer(answer, for: part, foundAfter: elapsed)
}

public func measure<T: CustomStringConvertible>(part: Part, _ closure: @escaping (Logger) throws -> T?) rethrows {
    let start = Date()
    let logger = Logger.measurements

    logger.critical("Starting \(part.title)...")
    let answer = try closure(logger)
    let end = Date()
    let elapsed: Duration = .milliseconds(end.timeIntervalSince(start) * 1000)
    logger.formatAnswer(answer, for: part, foundAfter: elapsed)
}

public func measure(part: Part, _ closure: @escaping (Logger) throws -> Void) rethrows {
    let start = Date()
    let logger = Logger.measurements

    logger.critical("Starting \(part.title)...")
    try closure(logger)
    let end = Date()
    let elapsed: Duration = .milliseconds(end.timeIntervalSince(start) * 1000)
    logger.critical("Finished \(part.title) [\(elapsed.formatElapsed())].")
}
