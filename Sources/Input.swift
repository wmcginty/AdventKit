//
//  File.swift
//  
//
//  Created by Will McGinty on 12/12/23.
//

import Foundation

public struct Input {

    // MARK: - Input.Error
    enum Error: Swift.Error {
        case downloadFailure(URLResponse)
        case noParentCacheDirectory
    }

    // MARK: - Properties
    public let day: Int
    public let year: Int
    public let session: URLSession
    public let fileManager: FileManager

    // MARK: - Initializer
    init(day: Int, year: Int, session: URLSession = .shared, fileManager: FileManager = .default) {
        self.day = day
        self.year = year
        self.session = session
        self.fileManager = fileManager
    }

    // MARK: - Interface
    public func fetchRemote() async throws -> String {
        if let cached = cachedInput() {
            return transform(inputData: cached)
        }

        let sessionToken = "53616c7465645f5f87b45706994a45fd289a57d63004fafb98138152d8b17260abb2f3b89778b88f931216697207d1f81b343c1415d1855ae666f44e0f773a36"

        var urlRequest = URLRequest(url: remoteURL)
        urlRequest.addValue("session=\(sessionToken)", forHTTPHeaderField: "Cookie")

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw Error.downloadFailure(response)
        }

        try cache(inputData: data)
        return transform(inputData: data)
    }
}

// MARK: - Helper
extension Input {

    var remoteURL: URL { return URL(string: "https://adventofcode.com/\(year)/day/\(day)/input")! }
    var cacheURL: URL { return URL.applicationSupportDirectory.appending(component: String(year)).appending(component: String(day)).appendingPathExtension("txt") }

    func cachedInput() -> Data? {
        return fileManager.contents(atPath: cacheURL.path)
    }

    func transform(inputData: Data) -> String {
        return String(data: inputData, encoding: .utf8) ?? ""
    }

    func cache(inputData: Data) throws {
        if fileManager.fileExists(atPath: cacheURL.path) {
            try fileManager.removeItem(at: cacheURL)
        }

        var isDirectory: ObjCBool = false
        let containerDirectoryPath = NSString(string: cacheURL.path).deletingLastPathComponent
        let containerExists = fileManager.fileExists(atPath: containerDirectoryPath, isDirectory: &isDirectory)

        if containerExists {
            guard isDirectory.boolValue else { throw Error.noParentCacheDirectory }
            _ = fileManager.createFile(atPath: cacheURL.path, contents: inputData)

        } else {
            try fileManager.createDirectory(atPath: containerDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            _ = fileManager.createFile(atPath: cacheURL.path, contents: inputData)
        }
    }
}
