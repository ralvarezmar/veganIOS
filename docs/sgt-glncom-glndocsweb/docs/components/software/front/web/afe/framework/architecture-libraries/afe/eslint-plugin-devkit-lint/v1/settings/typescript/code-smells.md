# Code Smells

By using the ***plugin:@afe/devkit-lint/typescript*** configuration, the project will rely on the following ESLint rules, and their respective settings, which infer code standardization

## Rules

### [@afe/devkit-lint/order-imports]

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "allowSeparatedGroups": true
    }
]
```

### [curly](https://eslint.org/docs/rules/curly)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Control structures should use curly braces](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS121&rule_key=typescript%3AS121) e [Multiline blocks should be enclosed in curly braces](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS2681&rule_key=typescript%3AS2681)

### [grouped-accessor-pairs](https://eslint.org/docs/rules/grouped-accessor-pairs)

- **Severity:** Alert
- **Configuration:** Default

### [id-length](https://eslint.org/docs/rules/id-length)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "min": 2
    }
]
```

### [linebreak-style](https://eslint.org/docs/rules/linebreak-style)

- **Severity:** Alert
- **Configuration:**

```json
["windows"]
```

### [max-classes-per-file](https://eslint.org/docs/rules/max-classes-per-file)

- **Severity:** Alert
- **Configuration:**

```json
[1]
```

### [max-len](https://eslint.org/docs/rules/max-len)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "code": 140
    }
]
```

> Anticipates Sonar rule [Lines should not be too long](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS103&rule_key=typescript%3AS103)

### [max-lines](https://eslint.org/docs/rules/max-lines)

- **Severity:** Error
- **Configuration:**

```json
[1000]
```

> Anticipates Sonar rule [Files should not have too many lines of code](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS104&rule_key=typescript%3AS104)

### [max-lines-per-function](https://eslint.org/docs/rules/max-lines-per-function)

- **Severity:** Error
- **Configuration:**

```json
[200]
```

> Anticipates Sonar rule [Functions should not have too many lines of code](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS138&rule_key=typescript%3AS138)

### [max-params](https://eslint.org/docs/rules/max-params)

- **Severity:** Error
- **Configuration:**

```json
[7]
```

> Anticipates Sonar rule [Functions should not have too many parameters](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS107&rule_key=typescript%3AS107)

### [max-statements-per-line](https://eslint.org/docs/rules/max-statements-per-line)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "max": 1
    }
]
```

> Anticipates Sonar rule [Statements should be on separate lines](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS122&rule_key=typescript%3AS122)

### [newline-before-return](https://eslint.org/docs/rules/newline-before-return)

- **Severity:** Alert
- **Configuration:** Default

### [newline-per-chained-call](https://eslint.org/docs/rules/newline-per-chained-call)

- **Severity:** Alert
- **Configuration:** Default

### [no-duplicate-imports](https://eslint.org/docs/rules/no-duplicate-imports)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "includeExports": true
    }
]
```

> Anticipates Sonar rule [Imports from the same modules should be merged](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3863&rule_key=typescript%3AS3863)

### [no-irregular-whitespace](https://eslint.org/docs/rules/no-irregular-whitespace)

- **Severity:** Alert
- **Configuration:** Default

### [no-mixed-spaces-and-tabs](https://eslint.org/docs/rules/no-mixed-spaces-and-tabs)

- **Severity:** Alert
- **Configuration:** Default

### [no-multi-spaces](https://eslint.org/docs/rules/no-multi-spaces)

- **Severity:** Alert
- **Configuration:** Default

### [object-shorthand](https://eslint.org/docs/rules/object-shorthand)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Object literal shorthand syntax should be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3498&rule_key=typescript%3AS3498)

### [sonarjs/no-duplicate-string](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-duplicate-string.md)

- **Severity:** Alert
- **Configuration:**

```json
[3]
```

> Anticipates Sonar rule [String literals should not be duplicated](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1192&rule_key=typescript%3AS1192)

### [sonarjs/no-same-line-conditional](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-same-line-conditional.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Conditionals should start on new lines](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3972&rule_key=typescript%3AS3972)

### [sonarjs/prefer-immediate-return](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/prefer-immediate-return.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Local variables should not be declared and then immediately returned or thrown](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1488&rule_key=typescript%3AS1488)

### [yoda](https://eslint.org/docs/rules/yoda)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/ban-tslint-comment](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/ban-tslint-comment.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/brace-style](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/brace-style.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    "1tbs",
    {
        "allowSingleLine": true
    }
]
```

### [@typescript-eslint/comma-dangle](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/comma-dangle.md)

- **Severity:** Alert
- **Configuration:**

```json
["always-multiline"]
```

### [@typescript-eslint/comma-spacing](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/comma-spacing.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/dot-notation](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/dot-notation.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/func-call-spacing](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/func-call-spacing.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/indent](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/indent.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/lines-between-class-members](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/lines-between-class-members.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    "always",
    {
        "exceptAfterSingleLine": true
    }
]
```

### [@typescript-eslint/member-delimiter-style](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/member-delimiter-style.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "multiline": {
            "delimiter": "semi",
            "requireLast": true
        },
        "singleline": {
            "delimiter": "semi",
            "requireLast": true
        }
    }
]
```

### [@typescript-eslint/member-ordering](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/member-ordering.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/method-signature-style](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/method-signature-style.md)

- **Severity:** Error
- **Configuration:**

```json
["property"]
```

### [@typescript-eslint/naming-convention](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/naming-convention.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "format": ["camelCase", "UPPER_CASE"],
        "leadingUnderscore": "allowSingleOrDouble",
        "selector": [
            "variable",
            "function",
            "parameter",
            "property",
            "method"
        ]
    },
    {
        "format": ["PascalCase"],
        "leadingUnderscore": "allowSingleOrDouble",
        "prefix": ["is", "should", "has", "can", "did", "will"],
        "selector": ["variable", "parameter"],
        "types": ["boolean"]
    }
]
```

### [@typescript-eslint/no-empty-function](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-empty-function.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/no-empty-interface](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-empty-interface.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "allowSingleExtends": false
    }
]
```

> Anticipates Sonar rule [Interfaces should not be empty](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4023&rule_key=typescript%3AS4023)

### [@typescript-eslint/no-extra-parens](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-extra-parens.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Redundant pairs of parentheses should be removed](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1110&rule_key=typescript%3AS1110)

### [@typescript-eslint/no-extra-semi](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-extra-semi.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Extra semicolons should be removed](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1116&rule_key=typescript%3AS1116)

### [@typescript-eslint/quotes](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/quotes.md)

- **Severity:** Alert
- **Configuration:**

```json
["single"]
```

> Anticipates Sonar rule [Quotes for string literals should be used consistently](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1441&rule_key=typescript%3AS1441)

### [@typescript-eslint/semi](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/semi.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Statements should end with semicolons](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1438&rule_key=typescript%3AS1438)

### [@typescript-eslint/type-annotation-spacing](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/type-annotation-spacing.md)

- **Severity:** Alert
- **Configuration:** Default
