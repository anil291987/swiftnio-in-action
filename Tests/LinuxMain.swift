import XCTest

import swiftnio_in_actionTests

var tests = [XCTestCaseEntry]()
tests += chapter1Tests.allTests()
tests += chapter2Tests.allTests()
tests += chapter4Tests.allTests()
XCTMain(tests)
