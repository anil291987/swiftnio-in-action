import XCTest

import swiftnio_in_actionTests

var tests = [XCTestCaseEntry]()
tests += swiftnio_in_actionTests.allTests()
tests += chapter1Tests.allTests()
XCTMain(tests)
