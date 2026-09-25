# Bugs

By using the configuration ***plugin:@afe/devkit-lint/typescript*** the project will have the following ESLint rules, and their respective settings, which infer the resolution of possible bugs that the code may contain

## Rules

### [@afe/devkit-lint/no-implicit-dependencies]

- **Severity:** Error
- **Configuration:** Default

### [array-callback-return](https://eslint.org/docs/rules/array-callback-return)

- **Severity:** Error
- **Configuration:** Default

### [consistent-return](https://eslint.org/docs/rules/consistent-return)

- **Severity:** Error
- **Configuration:** Default

### [for-direction](https://eslint.org/docs/rules/for-direction)

- **Severity:** Error
- **Configuration:** Default

### [no-bitwise](https://eslint.org/docs/rules/no-bitwise)

- **Severity:** Error
- **Configuration:** Default

### [no-cond-assign](https://eslint.org/docs/rules/no-cond-assign)

- **Severity:** Error
- **Configuration:**

```json
["always"]
```

> Anticipates Sonar rule [Assignments should not be made from within conditions](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1121&rule_key=typescript%3AS1121)

### [no-constructor-return](https://eslint.org/docs/rules/no-constructor-return)

- **Severity:** Error
- **Configuration:** Default

### [no-empty-pattern](https://eslint.org/docs/rules/no-empty-pattern)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Destructuring patterns should not be empty](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3799&rule_key=typescript%3AS3799)

### [no-fallthrough](https://eslint.org/docs/rules/no-fallthrough)

- **Severity:** Error
- **Configuration:** Default

### [no-global-assign](https://eslint.org/docs/rules/no-global-assign)

- **Severity:** Error
- **Configuration:** Default

### [no-invalid-regexp](https://eslint.org/docs/rules/no-invalid-regexp)

- **Severity:** Error
- **Configuration:** Default

### [no-misleading-character-class](https://eslint.org/docs/rules/no-misleading-character-class)

- **Severity:** Error
- **Configuration:** Default

### [no-param-reassign](https://eslint.org/docs/rules/no-param-reassign)

- **Severity:** Error
- **Configuration:** Default

### [no-promise-executor-return](https://eslint.org/docs/rules/no-promise-executor-return)

- **Severity:** Error
- **Configuration:** Default

### [no-self-assign](https://eslint.org/docs/rules/no-self-assign)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Variables should not be self-assigned](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1656&rule_key=typescript%3AS1656)

### [no-self-compare](https://eslint.org/docs/rules/no-self-compare)

- **Severity:** Error
- **Configuration:** Default

### [no-sequences](https://eslint.org/docs/rules/no-sequences)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Comma operator should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS878&rule_key=typescript%3AS878)

### [no-sparse-arrays](https://eslint.org/docs/rules/no-sparse-arrays)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Sparse arrays should not be declared](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4140&rule_key=typescript%3AS4140)

### [no-template-curly-in-string](https://eslint.org/docs/rules/no-template-curly-in-string)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Template literal placeholder syntax should not be used in regular strings](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3786&rule_key=typescript%3AS3786)

### [no-unmodified-loop-condition](https://eslint.org/docs/rules/no-unmodified-loop-condition)

- **Severity:** Error
- **Configuration:** Default

### [no-unreachable](https://eslint.org/docs/rules/no-unreachable)

- **Severity:** Alert
- **Configuration:** Default

### [no-unsafe-finally](https://eslint.org/docs/rules/no-unsafe-finally)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Jump statements should not occur in "finally" blocks](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1143&rule_key=typescript%3AS1143)

### [require-atomic-updates](https://eslint.org/docs/rules/require-atomic-updates)

- **Severity:** Error
- **Configuration:** Default

### [sonarjs/no-unused-collection](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-unused-collection.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Collection and array contents should be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4030&rule_key=typescript%3AS4030)

### [sonarjs/no-use-of-empty-return-value](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-use-of-empty-return-value.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [The output of functions that don't return anything should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3699&rule_key=typescript%3AS3699)

### [use-isnan](https://eslint.org/docs/rules/use-isnan)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "enforceForIndexOf": true
    }
]
```

> Anticipates Sonar rule ["NaN" should not be used in comparisons](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS2688&rule_key=typescript%3AS2688)

### [@typescript-eslint/no-base-to-string](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-base-to-string.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-redeclare](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-redeclare.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Variables should not be redeclared](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS2814&rule_key=typescript%3AS2814)

### [@typescript-eslint/no-shadow](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-shadow.md)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "builtinGlobals": true
    }
]
```

> Anticipates Sonar rule [Variables should not be shadowed](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1524&rule_key=typescript%3AS1524)

### [@typescript-eslint/no-unused-expressions](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unused-expressions.md)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "allowShortCircuit": true,
        "allowTernary": true
    }
]
```

> Anticipates Sonar rule [Non-empty statements should change control flow or have at least one side-effect](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS905&rule_key=typescript%3AS905)

### [@typescript-eslint/no-use-before-define](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-use-before-define.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Variables should be declared before they are used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1526&rule_key=typescript%3AS1526)

### [@typescript-eslint/restrict-plus-operands](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/restrict-plus-operands.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/restrict-template-expressions](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/restrict-template-expressions.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/unbound-method](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/unbound-method.md)

- **Severity:** Error
- **Configuration:** Default
