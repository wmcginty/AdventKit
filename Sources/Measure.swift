//
//  Measure.swift
//  
//
//  Created by Will McGinty on 12/19/22.
//

import Foundation
import OSLog
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

    Logger.measurements.critical("Starting \(part.title)...")
    let answer = try closure()

    let end = Date()
    let elapsed: Duration = .milliseconds(end.timeIntervalSince(start))
    let formatStyle = Duration.UnitsFormatStyle(allowedUnits: [.nanoseconds, .microseconds, .milliseconds, .seconds, .minutes],
                                                width: .narrow)
    Logger.measurements.critical("Finished \(part.title) [\(elapsed.formatted(formatStyle))]. Answer: \(answer)")
}
