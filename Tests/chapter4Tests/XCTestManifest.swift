import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(chapter4Tests.allTests),
    ]
}
#endif


