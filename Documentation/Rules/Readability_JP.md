# Readability ルール

## High Non-Commenting Source Statements

<dl>
<dt>識別子</dt>
<dd>high_ncss</dd>
<dt>ファイル名</dt>
<dd>NCSSRule.swift</dd>
<dt>激しさ</dt>
<dd>Major</dd>
<dt>分類</dt>
<dd>Readability</dd>
</dl>

This rule counts number of lines for a method by
counting Non Commenting Source Statements (NCSS).

NCSS only takes actual statements into consideration,
in other words, ignores empty statements, empty blocks,
closing brackets or semicolons after closing brackets.

Meanwhile, a statement that is broken into multiple lines contribute only one count.

##### Thresholds:

<dl>
<dt>NCSS</dt>
<dd>The high NCSS method reporting threshold, default value is 30.</dd>
</dl>

##### Examples:

###### Example 1

```
func example()          // 1
{
    if (1)              // 2
    {
    }
    else                // 3
    {
    }
}
```


## Nested Code Block Depth

<dl>
<dt>識別子</dt>
<dd>nested_code_block_depth</dd>
<dt>ファイル名</dt>
<dd>NestedCodeBlockDepthRule.swift</dd>
<dt>激しさ</dt>
<dd>Major</dd>
<dt>分類</dt>
<dd>Readability</dd>
</dl>

This rule indicates blocks nested more deeply than the upper limit.

##### Thresholds:

<dl>
<dt>NESTED_CODE_BLOCK_DEPTH</dt>
<dd>The depth of a code block reporting threshold, default value is 5.</dd>
</dl>

##### Examples:

###### Example 1

```
if (1)
{               // 1
    {           // 2
        {       // 3
        }
    }
}
```
