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

class NPathComplexityRuleTests : XCTestCase {
  func testEmptyCodeBlock() {
    XCTAssertTrue(getIssues(from: "func foo()").isEmpty)
    XCTAssertTrue(getIssues(from: "init() {}").isEmpty)
    XCTAssertTrue(getIssues(from: "deinit {}").isEmpty)
    XCTAssertTrue(getIssues(from: "subscript() -> Self {}").isEmpty)
  }

  func testIfStatement() {
    let issues = getIssues(from: "func foo() { if bar {} }")
    XCTAssertEqual(issues.count, 1)
    let issue = issues[0]
    XCTAssertEqual(issue.ruleIdentifier, "high_npath_complexity")
    XCTAssertEqual(issue.description, "NPath Complexity number of 2 exceeds limit of 1")
    XCTAssertEqual(issue.category, .complexity)
    XCTAssertEqual(issue.severity, .major)
    let range = issue.location
    XCTAssertEqual(range.start.path, "test/test")
    XCTAssertEqual(range.start.line, 1)
    XCTAssertEqual(range.start.column, 1)
    XCTAssertEqual(range.end.path, "test/test")
    XCTAssertEqual(range.end.line, 1)
    XCTAssertEqual(range.end.column, 25)
  }

  func testSwitchStatement() {
    let issues = getIssues(from: "init() { switch foo  { case a, b where b && a: break; default: break;} }")
    XCTAssertEqual(issues.count, 1)
    let issue = issues[0]
    XCTAssertEqual(issue.ruleIdentifier, "high_npath_complexity")
    XCTAssertEqual(issue.description, "NPath Complexity number of 4 exceeds limit of 1")
    XCTAssertEqual(issue.category, .complexity)
    XCTAssertEqual(issue.severity, .major)
    let range = issue.location
    XCTAssertEqual(range.start.path, "test/test")
    XCTAssertEqual(range.start.line, 1)
    XCTAssertEqual(range.start.column, 1)
    XCTAssertEqual(range.end.path, "test/test")
    XCTAssertEqual(range.end.line, 1)
    XCTAssertEqual(range.end.column, 73)
  }

  func testTernaryConditionalOperatorExpression() {
    let issues = getIssues(from: "deinit { c ? t : f }")
    XCTAssertEqual(issues.count, 1)
    let issue = issues[0]
    XCTAssertEqual(issue.ruleIdentifier, "high_npath_complexity")
    XCTAssertEqual(issue.description, "NPath Complexity number of 2 exceeds limit of 1")
    XCTAssertEqual(issue.category, .complexity)
    XCTAssertEqual(issue.severity, .major)
    let range = issue.location
    XCTAssertEqual(range.start.path, "test/test")
    XCTAssertEqual(range.start.line, 1)
    XCTAssertEqual(range.start.column, 1)
    XCTAssertEqual(range.end.path, "test/test")
    XCTAssertEqual(range.end.line, 1)
    XCTAssertEqual(range.end.column, 21)
  }

  func testDoStatement() {
    let issues = getIssues(from: "subscript() -> Self { do { try foo() } catch e1 {} catch e2 {} catch {} }")
    XCTAssertEqual(issues.count, 1)
    let issue = issues[0]
    XCTAssertEqual(issue.ruleIdentifier, "high_npath_complexity")
    XCTAssertEqual(issue.description, "NPath Complexity number of 4 exceeds limit of 1")
    XCTAssertEqual(issue.category, .complexity)
    XCTAssertEqual(issue.severity, .major)
    let range = issue.location
    XCTAssertEqual(range.start.path, "test/test")
    XCTAssertEqual(range.start.line, 1)
    XCTAssertEqual(range.start.column, 1)
    XCTAssertEqual(range.end.path, "test/test")
    XCTAssertEqual(range.end.line, 1)
    XCTAssertEqual(range.end.column, 74)
  }

  private func getIssues(from content: String) -> [Issue] {
    return content.inspect(
      withRule: NPathComplexityRule(),
      configurations: [NPathComplexityRule.ThresholdKey: 1]
    )
  }

  static var allTests = [
    ("testEmptyCodeBlock", testEmptyCodeBlock),
    ("testIfStatement", testIfStatement),
    ("testSwitchStatement", testSwitchStatement),
    ("testTernaryConditionalOperatorExpression", testTernaryConditionalOperatorExpression),
    ("testDoStatement", testDoStatement),
  ]
}