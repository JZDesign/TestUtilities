// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation


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
