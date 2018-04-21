import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(swiftnio_in_actionTests.allTests),
    ]
}
#endif