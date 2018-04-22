import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(chapter2Tests.allTests),
    ]
}
#endif
