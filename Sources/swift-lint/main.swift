/*
   Copyright 2015-2017 Ryuichi Saito, LLC and the Yanagiba project contributors

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

import Foundation

import Source
import Lint

var cliArgs = CommandLine.arguments
cliArgs.remove(at: 0)

func argumentsContain(_ option: String) -> Bool {
  return !cliArgs.filter({ $0 == "-\(option)" || $0 == "--\(option)" }).isEmpty
}

func readOption(_ option: String) -> String? {
  guard let argIndex = cliArgs.index(of: "--\(option)") else {
    return nil
  }

  let argValueIndex = cliArgs.index(after: argIndex)
  guard argValueIndex < cliArgs.count else {
    return nil
  }

  let option = cliArgs[argValueIndex]
  cliArgs.removeSubrange(argIndex...argValueIndex)
  return option
}

if argumentsContain("help") {
  print("""
  swift-lint [options] <source0> [... <sourceN>]

  <source0> ... specify the paths of source files.

  -help, --help
    Display available options
  -version, --version
    Display the version

  --enable-rules <rule_identifier0>[,...,<rule_identifierN>]
    Enable rules, default to all rules
  --disable-rules <rule_identifier0>[,...,<rule_identifierN>]
    Disable rules, default to empty
  --rule-configure <parameter0>=<value0>[,...,<parameterN>=<valueN>]
    Override the default rule configurations

  --report-type <report_identifier>
    Change output report type, default to `text`
  -o, --output <path>
    Write output to <path>, default to console

  --severity-thresholds <severity0>=<threshold0>[,...,<severityN>=<thresholdN>]
    The max allowed number of issues of each severity level.
    Critical is default to 0
    Major is default to 10
    Minor is default to 20
    Cosmetic is default to 50

  For more information, please visit http://yanagiba.org/swift-lint
  """)
  exit(0)
}

if argumentsContain("version") {
  print("""
  Yanagiba's swift-lint (http://yanagiba.org/swift-lint):
    version \(SWIFT_LINT_VERSION).

  Yanagiba's swift-ast (http://yanagiba.org/swift-ast):
    version \(SWIFT_AST_VERSION).
  """)
  exit(0)
}

var enabledRules = [
  "no_force_cast", // TODO: need better approach
  "no_forced_try",
  "high_cyclomatic_complexity",
  "high_npath_complexity",
  "high_ncss",
  "nested_code_block_depth",
  "remove_get_for_readonly_computed_property",
  "redundant_initialization_to_nil",
  "redundant_if_statement",
  "redundant_conditional_operator",
  "constant_if_statement_condition",
  "constant_guard_statement_condition",
  "constant_conditional_operator",
  "inverted_logic",
  "double_negative",
  "collapsible_if_statements",
  "redundant_variable_declaration_keyword",
  "redundant_enumcase_string_value",
]
if let enableRulesOption = readOption("enable-rules") {
  enabledRules = enableRulesOption.components(separatedBy: ",")
}
if let disableRulesOption = readOption("disable-rules") {
  let disabledRuleIdentifiers = disableRulesOption.components(separatedBy: ",")
  enabledRules = enabledRules.filter({ !disabledRuleIdentifiers.contains($0) })
}

var ruleConfigurations: [String: Any]?
if let customRuleConfigOption = readOption("rule-configure") {
  ruleConfigurations = customRuleConfigOption.components(separatedBy: ",")
    .flatMap({ opt -> (String, Int)? in // TODO: need to support other types
      let keyValuePair = opt.components(separatedBy: "=")
      guard keyValuePair.count == 2 else {
        return nil
      }
      let key = keyValuePair[0]
      let valueString = keyValuePair[1]
      guard let valueInt = Int(valueString) else {
        return nil
      }
      return (key, valueInt)
    }).reduce([:]) { (carryOver, arg) -> [String: Any] in
      var mutableDict = carryOver
      mutableDict[arg.0] = arg.1
      return mutableDict
    }
}

let reportType = readOption("report-type") ?? "text"

let filePaths = cliArgs
var sourceFiles = [SourceFile]()
for filePath in filePaths {
  guard let sourceFile = try? SourceReader.read(at: filePath) else {
    print("Can't read file \(filePath)")
    exit(-1)
  }
  sourceFiles.append(sourceFile)
}

let driver = Driver(ruleIdentifiers: enabledRules, reportType: reportType)
let exitCode = driver.lint(sourceFiles: sourceFiles, ruleConfigurations: ruleConfigurations)
exit(exitCode.rawValue)
