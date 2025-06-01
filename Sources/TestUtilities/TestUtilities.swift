// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import XCTest

/// Allow the OS to pick up a `Task`
/// 
/// - Parameter priority: The task priority to wait on. Must be lower than the other task you'd like to wait for
///
/// This is useful when a function is not async and opens a `Task` and you need to have a deterministic way to ensure that task executes.
///
public func suspend(priority: TaskPriority = .low) async {
    await Task(priority: priority) {
        await Task.yield()
    }.value
}

public extension XCTestCase {
    
    /// Initialize your class and track whether or not it's been deallocated by the end of your test
    /// - Parameters:
    ///   - initializer: MyClass() -- This is an autoclosure, so
    ///   - file: The file path
    ///   - line: The line
    /// - Returns: The initialized object
    func createAndTrackMemoryLeaks<T: AnyObject & Sendable>(
        _ initializer: @autoclosure () -> T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> T {
        let instance = initializer()
        trackForMemoryLeaks(instance, file: file, line: line)
        return instance
    }
    
    func trackForMemoryLeaks(_ instance: AnyObject & Sendable, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
