# Code Smells

By using the configuration ***plugin:@afe/devkit-lint/javascript*** the project will have the following ESLint rules, and their respective settings, that infer in the standardization of the code

## Rules

## [@afe/devkit-lint/order-imports]

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

### [max-lines](https://eslint.org/docs/rules/max-lines)

- **Severity:** Error
- **Configuration:**

```json
[1000]
```

### [max-lines-per-function](https://eslint.org/docs/rules/max-lines-per-function)

- **Severity:** Error
- **Configuration:**

```json
[200]
```

### [max-params](https://eslint.org/docs/rules/max-params)

- **Severity:** Error
- **Configuration:**

```json
[7]
```

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

### [sonarjs/no-duplicate-string](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-duplicate-string.md)

- **Severity:** Alert
- **Configuration:**

```json
[3]
```

### [sonarjs/no-same-line-conditional](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-same-line-conditional.md)

- **Severity:** Error
- **Configuration:** Default

### [sonarjs/prefer-immediate-return](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/prefer-immediate-return.md)

- **Severity:** Alert
- **Configuration:** Default

### [yoda](https://eslint.org/docs/rules/yoda)

- **Severity:** Alert
- **Configuration:** Default

### [brace-style](https://eslint.org/docs/rules/brace-style)

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

### [comma-dangle](https://eslint.org/docs/rules/comma-dangle)

- **Severity:** Alert
- **Configuration:**

```json
["always-multiline"]
```

### [comma-spacing](https://eslint.org/docs/rules/comma-spacing)

- **Severity:** Alert
- **Configuration:** Default

### [dot-notation](https://eslint.org/docs/rules/dot-notation)

- **Severity:** Error
- **Configuration:** Default

### [func-call-spacing](https://eslint.org/docs/rules/func-call-spacing)

- **Severity:** Alert
- **Configuration:** Default

### [indent](https://eslint.org/docs/rules/indent)

- **Severity:** Alert
- **Configuration:** Default

### [lines-between-class-members](https://eslint.org/docs/rules/lines-between-class-members)

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

### [no-empty-function](https://eslint.org/docs/rules/no-empty-function)

- **Severity:** Alert
- **Configuration:** Default

### [no-empty-interface](https://eslint.org/docs/rules/no-empty-interface)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "allowSingleExtends": false
    }
]
```

### [no-extra-parens](https://eslint.org/docs/rules/no-extra-parens)

- **Severity:** Error
- **Configuration:** Default

### [no-extra-semi](https://eslint.org/docs/rules/no-extra-semi)

- **Severity:** Alert
- **Configuration:** Default

### [quotes](https://eslint.org/docs/rules/quotes)

- **Severity:** Alert
- **Configuration:**

```json
["single"]
```

### [semi](https://eslint.org/docs/rules/semi)

- **Severity:** Alert
- **Configuration:** Default
