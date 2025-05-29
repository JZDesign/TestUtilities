//
//  JSONFileManager.swift
//  TestUtilities
//
//  Created by Jacob Rakidzich on 5/29/25.
//

import Foundation

public struct JSONFileManager {
    private let filemanager: FileManager
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder = {
        var coder = JSONEncoder()
        coder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return coder
    }()
    
    // MARK: - Init
    
    public init(fileManager: FileManager = .default, decoder: JSONDecoder = .init()) {
        self.filemanager = fileManager
        self.decoder = decoder
    }
    
    // MARK: - Public API
    
    /// Decode the contents of a file into some Codable type
    /// - Parameters:
    ///   - fileName: The name of the file to load (without a file extension)
    ///   - folder: The name of the folder the file is in in comparrison to the current directory of the file calling this function
    ///   - filepath: The filepath of the file that is calling this function
    ///
    ///  [NOTE] If you use #file instead of #filepath, this will read and write at the build location starting in Swift 6 instead of locally to the project because of the following change https://github.com/swiftlang/swift-evolution/blob/main/proposals/0274-magic-file.md
    ///
    /// - Returns: T
    public func load<T: Codable>(from fileName: String, inFolderNamed folder: String = "JSON", withFolderAsSiblingToFile filepath: String = #filePath) throws -> T {
        let url = fileURL(with: fileName, inFolder: folder, withFolderAsSiblingToFile: filepath)
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }
    
    
    /// Decode the contents of a file into a String
    /// - Parameters:
    ///   - fileName: The name of the file to load (without a file extension)
    ///   - folder: The name of the folder the file is in in comparrison to the current directory of the file calling this function
    ///   - filepath: The filepath of the file that is calling this function
    /// - Returns: String
    public func readString(from fileName: String, inFolderNamed folder: String = "JSON", withFolderAsSiblingToFile filepath: String = #filePath) throws -> String {
        let url = fileURL(with: fileName, inFolder: folder, withFolderAsSiblingToFile: filepath)
        let data = try Data(contentsOf: url)

        guard let value = String(data: data, encoding: .utf8) else {
            throw Errors.couldNotDecodeData
        }

        return value
    }


    /// Store the JSON of some Codable type into a file
    /// - Parameters:
    ///   - data: The codable data you want to save
    ///   - fileName: The name of the file to save (without a file extension)
    ///   - folder: The name of the folder the file is in in comparrison to the current directory of the file calling this function
    ///   - filepath: The filepath of the file that is calling this function
    public func store<T: Codable>(_ data: T, toFileWithName fileName: String, inFolderNamed folder: String = "JSON", withFolderAsSiblingToFile filepath: String = #filePath) throws {
        let url = fileURL(with: fileName, inFolder: folder, withFolderAsSiblingToFile: filepath)
        try filemanager
            .createDirectory(
                at: url.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
        try encoder
            .encode(data)
            .write(to: url)
    }
    
    // MARK: - Helper Methods
    
    private func fileURL(with name: String, inFolder: String, withFolderAsSiblingToFile filepath: String) -> URL {
        URL(fileURLWithPath: String(describing: filepath))
            .deletingLastPathComponent()
            .appendingPathComponent(inFolder)
            .appendingPathComponent(name + ".json")
    }
    
    public enum Errors: Error {
        case couldNotDecodeData
    }
}
