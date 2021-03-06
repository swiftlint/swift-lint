# Suppress Issues

When the standard for certain code measurement is controversial or simply not applicable in your team setting, you might want to consider suppressing issues with one of the few methods:

- If the situation of your project is slightly different from our default settings, consider
  - [changing rule configurations](RuleConfigurations.md)
  - [disabling rules](SelectRules.md)
- If it is a case-by-case thing, and only particular places need to be suppressed
  - [Use inline comment based suppression](#inline-comment)

> **See Also:** To disable rules or use of comment based suppression, you will need to know the rule identifiers.
You can browse the [Rule Index](Rules),
and look for `Identifier` under each rule's title.

> **Note:** When it's a bug or a false positive, don't just suppress it, speak out loud! Let us know by opening an issue with your code snippet on GitHub, and we'll take a look. Even better, you can patch test cases, amend the rule to make tests pass, and submit a pull request with your fix. Your help is highly appreciated.

## Inline Comment

You can suppress issues by appending comment with special annotations that are prefixed with `swift-lint:suppress`. We support suppress [one rule](#suppress-one-rule), [multiple rules](#suppress-multiple-rules), and [all rules](#suppress-all-rules).

### Suppress One Rule

To suppress one rule for the particular line, you can write single line comment to the same line, like

```
// swift-lint:suppress(rule_identifier)
```

Or multi-line comment of which the head `/*` is on the same line:

```
/* swift-lint:suppress(rule_identifier) */
```

For example, when a block of code is intended to be very nested, you can suppress it:

```
for _ in foo..<bar { // swift-lint:suppress(nested_code_block_depth)
  .. nested code
}
```

or

```
for _ in foo..<bar /*
  swift-lint:suppress(nested_code_block_depth)
  */
{
  .. nested code
}
```

you should choose the style that optimizes for readability.

### Suppress Multiple Rules

To suppress multiple rules altogether, few syntaxes are available:

- All rule identifiers in one `suppress` call inside single line comment

```
// swift-lint:suppress(rule_identifier_1,...,rule_identifier_N)
```

- Multiple `suppress` calls in single line comment

```
// swift-lint:suppress(rule_identifier_1):suppress(rule_identifier_2):...:suppress(rule_identifier_N)
```

- One `suppress` call with all rule identifiers inside a multi-line comment block

```
/*
 swift-lint:suppress(rule_identifier_1,...,rule_identifier_N)
 */
```

- Multiple `suppress` calls in multi-line comment block

```
/*
 swift-lint:suppress(rule_identifier_1)
 swift-lint:suppress(rule_identifier_2)
 ...
 swift-lint:suppress(rule_identifier_N)
 */
```

Single line comment will suppress the issues emitted from the same line of code,
and multi-line comment will suppress the issues emitted from the line as its head `/*` resides.

For instance, you want to suppress issues from few metrics based rules, here is what you can do:

```
func foo() { /*
 swift-lint:suppress(high_cyclomatic_complexity)
 swift-lint:suppress(high_npath_complexity)
 swift-lint:suppress(high_ncss)
 swift-lint:suppress(nested_code_block_depth)
 */
  .. even more complex code
}
```

### Suppress All Rules

When you just want to suppress everything, you give no rule identifier to the `suppress` call, and simply provide a pair of parenthesis `()`.

> **Warning:** All future introduced rules will be suppressed as well, so use it with caution.

For example:

```
func foo() { // swift-lint:suppress()
  .. way too messy code
}
```

> **See Also:** You can mix `suppress` with other comment based annotations, like [changing rule configurations](RuleConfigurations.md), in the same comment block.
