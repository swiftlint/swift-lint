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

import Foundation

import Lint

class ArrayClass<T> {
  // Note: this is only for performance reasons
  // but since we lose the benefits of being a struct,
  // use it with cautious
  var elements: [T] = []
  func append(_ value: T) {
    elements.append(value)
  }
}

extension Issue.Category {
  var title: String {
    switch self {
    case .uncategorized:
      return "Uncategorized"
    case .badPractice:
      return "Bad Practice"
    case .readability:
      return "Readability"
    case .complexity:
      return "Complexity"
    case .size:
      return "Code Size"
    }
  }

  var fileName: String {
    return title.components(separatedBy: .whitespaces).joined()
  }
}

extension Issue.Severity {
  var title: String {
    return "\(self)".capitalized
  }
}

func groupedRuleSet() -> [Issue.Category: [Rule]] {
  var groupedDict: [Issue.Category: ArrayClass<Rule>] = [:]
  for e in RuleSet.rules {
    let key = e.category
    if let groupedArray = groupedDict[key] {
      groupedArray.append(e)
    } else {
      let groupedArray = ArrayClass<Rule>()
      groupedArray.append(e)
      groupedDict[key] = groupedArray
    }
  }
  var result: [Issue.Category: [Rule]] = [:]
  for (key, value) in groupedDict {
    result[key] = value.elements
  }
  return result
}

let pwd = FileManager.default.currentDirectoryPath
let docRoot = "\(pwd)/Documentation/Rules"

for (category, rules) in groupedRuleSet() {
  let filePath = "\(docRoot)/\(category.fileName).md"

  let title = "# \(category.title) Rules"

  let rulesContent = rules.map { rule -> String in
    var content = "## \(rule.name)\n\n"
    content += "Identifier: `\(rule.identifier)`\n\n"
    content += "Severity: \(rule.severity.title)\n\n"
    content += "Category: \(rule.category.title)\n\n"
    content += "\(rule.description)\n\n"
    content += rule.markdown
    return content
  }

  let content = ([title] + rulesContent).joined(separator: "\n\n")

  try content.write(toFile: filePath, atomically: true, encoding: .utf8)
}
