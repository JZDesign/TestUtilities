import Testing
import TestUtilities

@Test func suspendTest() async throws {
    let mock = SomeMock()
    
    mock.invoke()
    await suspend()
    
    #expect(mock.wasInvoked == true)
}

class SomeMock: @unchecked Sendable {
    var wasInvoked = false
    
    func invoke() {
        Task { [weak self] in
            self?.wasInvoked = true
        }
    }
}
