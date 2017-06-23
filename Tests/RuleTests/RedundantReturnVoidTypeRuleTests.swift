/*
   Copyright 2017 Ryuichi Saito, LLC and the Yanagiba project contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import XCTest

@testable import Lint

class RedundantReturnVoidTypeRuleTests : XCTestCase {
  func testNoReturnType() {
    let issues = "func foo()".inspect(withRule: RedundantReturnVoidTypeRule())
    XCTAssertTrue(issues.isEmpty)
  }

  func testReturnTypeIsNotVoid() {
    let issues = """
      func foo() -> Foo
      func foo() -> (Foo)
      """.inspect(withRule: RedundantReturnVoidTypeRule())
    XCTAssertTrue(issues.isEmpty)
  }

  func testReturnVoid() {
    let issues = "func foo() -> Void".inspect(withRule: RedundantReturnVoidTypeRule())
    XCTAssertEqual(issues.count, 1)
    let issue = issues[0]
    XCTAssertEqual(issue.ruleIdentifier, "redundant_return_void_type")
    XCTAssertEqual(issue.description, "`-> Void` is redundant and can be removed")
    XCTAssertEqual(issue.category, .badPractice)
    XCTAssertEqual(issue.severity, .minor)
    let range = issue.location
    XCTAssertEqual(range.start.path, "test/test")
    XCTAssertEqual(range.start.line, 1)
    XCTAssertEqual(range.start.column, 1)
    XCTAssertEqual(range.end.path, "test/test")
    XCTAssertEqual(range.end.line, 1)
    XCTAssertEqual(range.end.column, 19)
  }

  func testReturnEmptyTuple() {
    let issues = "func foo() -> ()".inspect(withRule: RedundantReturnVoidTypeRule())
    XCTAssertEqual(issues.count, 1)
    let issue = issues[0]
    XCTAssertEqual(issue.ruleIdentifier, "redundant_return_void_type")
    XCTAssertEqual(issue.description, "`-> ()` is redundant and can be removed")
    XCTAssertEqual(issue.category, .badPractice)
    XCTAssertEqual(issue.severity, .minor)
    let range = issue.location
    XCTAssertEqual(range.start.path, "test/test")
    XCTAssertEqual(range.start.line, 1)
    XCTAssertEqual(range.start.column, 1)
    XCTAssertEqual(range.end.path, "test/test")
    XCTAssertEqual(range.end.line, 1)
    XCTAssertEqual(range.end.column, 17)
  }

  static var allTests = [
    ("testNoReturnType", testNoReturnType),
    ("testReturnTypeIsNotVoid", testReturnTypeIsNotVoid),
    ("testReturnVoid", testReturnVoid),
    ("testReturnEmptyTuple", testReturnEmptyTuple),
  ]
}