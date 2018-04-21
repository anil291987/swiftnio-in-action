import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(chapter1Tests.allTests),
    ]
}
#endif

