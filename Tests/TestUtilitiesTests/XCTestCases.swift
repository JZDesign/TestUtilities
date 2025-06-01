import Combine
import Foundation
import TestUtilities
import XCTest

class AutoMemoryLeakTracking: XCTestCase {
    func test_MemoryLeakTrackingWorks() {
        XCTExpectFailure("This should have a memory leak")
        let instance = createAndTrackMemoryLeaks(PoorlyWrittenClass())
        print(instance.job as Any)
    }
    
    func test_MemoryLeakTrackingWorks_noLeak() {
        let instance = createAndTrackMemoryLeaks(WellWrittenClass())
        print(instance.job as Any)
    }
    
}

class PoorlyWrittenClass: @unchecked Sendable {
    var job: Cancellable?
    
    init() {
        job = Just(UUID()).sink { uuid in
            self.doSomethingWith(uuid: uuid)
        }
    }
    
    private func doSomethingWith(uuid: UUID) {
        DispatchQueue.main.async {
            print(self.job as Any)
            print(uuid)
        }
    }
}

class WellWrittenClass: @unchecked Sendable {
    var job: Cancellable?
    
    init() {
        job = Just(UUID()).sink { [weak self] uuid in
            self?.doSomethingWith(uuid: uuid)
        }
    }
    
    private func doSomethingWith(uuid: UUID) {
        DispatchQueue.main.async { [weak self] in
            print(self?.job as Any)
            print(uuid)
        }
    }
}
