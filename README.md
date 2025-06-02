# Swift testing utilities

This is a collection of things that I find helpful when writing tests like:

- JSON file storage (Reading and Writing) — I use it for codable model and logging tests mostly
- The `suspend` utility function which is useful for getting a nested `Task` to fire in a deterministic way
- The `createAndTrackMemoryLeaks` utility function for **XCTest** that allows you to ensure you haven't written a memory leak.

As I find other bits of code that are useful in a test environment, I'll add them here.
