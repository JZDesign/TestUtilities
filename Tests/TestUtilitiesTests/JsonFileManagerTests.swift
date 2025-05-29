import Foundation
import Testing
import TestUtilities

@Test func jsonTests() throws {
    let jsonManager = JSONFileManager(fileManager: .default)
    let value = MyCodable(title: "Testing", content: .init(description: "What a deal", value: 2))
    try jsonManager.store(value, toFileWithName: "Test")
    let newData: MyCodable = try jsonManager.load(from: "Test")
    let jsonData = try jsonManager.readString(from: "Test")
    #expect(value == newData)
    #expect(jsonData == json)
}


// Note that its 2 spaces (not tabs) and there is a space on both sides of the colons
let json = """
{
  "content" : {
    "description" : "What a deal",
    "value" : 2
  },
  "title" : "Testing"
}
"""

struct MyCodable: Codable, Equatable {
    let title: String
    let content: Nested
    
    struct Nested: Codable, Equatable {
        let description: String
        let value: Int
    }
}
