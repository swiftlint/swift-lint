/*
   Copyright 2015 Ryuichi Saito, LLC

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

import Spectre

@testable import ast
@testable import lint

func specRuleProtocol() {
    class LazyRule: Rule {
        var name: String {
            return "Do Nothing"
        }
        func emitIssue(issue: Issue) {}
        func inspect(ast: ASTContext, configurations: [String: AnyObject]?) {}
    }

    describe("a rule implementation with just a name") {
        $0.it("should have default attributes and its given name") {
            let lazyRule = LazyRule()
            try expect(lazyRule.identifier) == "do_nothing"
            try expect(lazyRule.name) == "Do Nothing"
            try expect(lazyRule.description.isEmpty).to.beTrue()
            try expect(lazyRule.markdown.isEmpty).to.beTrue()
        }
    }

    describe("a rule with a name that contains so many white spaces") {
        $0.it("should be trimmed in identifier") {
            class TooManySpacesRule: LazyRule {
                override var name: String {
                    return "I   Typed     Too        Many                Spaces"
                }
            }
            let tooManySpacesRule = TooManySpacesRule()
            try expect(tooManySpacesRule.identifier) == "i_typed_too_many_spaces"
        }
    }

    describe("a rule with an identifier that is not generated by default") {
        $0.it("should honor that identifier") {
            class WithCustomIdentifierRule: LazyRule {
                override var name: String {
                    return "Rule Name"
                }

                var identifier: String {
                    return "rule_identifier"
                }
            }
            let customIdentifierRule = WithCustomIdentifierRule()
            try expect(customIdentifierRule.identifier) == "rule_identifier"
            try expect(customIdentifierRule.name) == "Rule Name"
        }
    }

    describe("a rule has name that contains punctuations") {
        $0.it("should remove the punctuations") {
            class NameHasPunctuationsRule: LazyRule {
                override var name: String {
                    return "(Critical) May the Force be with y'all, always!"
                }
            }
            let customIdentifierRule = NameHasPunctuationsRule()
            try expect(customIdentifierRule.identifier) == "critical_may_the_force_be_with_yall_always"
        }
    }
}
