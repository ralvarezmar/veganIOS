# Best Practices

By using the ***plugin:@afe/devkit-lint/typescript*** configuration, the project will rely on the following ESLint rules, and their respective settings, that infer good coding practices

## Rules

### [accessor-pairs](https://eslint.org/docs/rules/accessor-pairs)

- **Severity:** Alert
- **Configuration:** Default

### [complexity](https://eslint.org/docs/rules/complexity)

- **Severity:** Error
- **Configuration:**

```json
[30]
```

> Anticipates Sonar rule [Functions should not be too complex](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1541&rule_key=typescript%3AS1541)

### [default-case](https://eslint.org/docs/rules/default-case)

- **Severity:** Alert
- **Configuration:** Default

### [default-case-last](https://eslint.org/docs/rules/default-case-last)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule ["default" clauses should be last](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4524&rule_key=typescript%3AS4524)

### [eqeqeq](https://eslint.org/docs/rules/eqeqeq)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule ["===" and "!==" should be used instead of "==" and "!="](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1440&rule_key=typescript%3AS1440)

### [getter-return](https://eslint.org/docs/rules/getter-return)

- **Severity:** Error
- **Configuration:** Default

### [guard-for-in](https://eslint.org/docs/rules/guard-for-in)

- **Severity:** Alert
- **Configuration:** Default

### [no-alert](https://eslint.org/docs/rules/no-alert)

- **Severity:** Alert
- **Configuration:** Default

### [no-async-promise-executor](https://eslint.org/docs/rules/no-async-promise-executor)

- **Severity:** Error
- **Configuration:** Default

### [no-await-in-loop](https://eslint.org/docs/rules/no-await-in-loop)

- **Severity:** Alert
- **Configuration:** Default

### [no-caller](https://eslint.org/docs/rules/no-caller)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule ["arguments.callee" should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS2685&rule_key=typescript%3AS2685)

### [no-case-declarations](https://eslint.org/docs/rules/no-case-declarations)

- **Severity:** Alert
- **Configuration:** Default

### [no-compare-neg-zero](https://eslint.org/docs/rules/no-compare-neg-zero)

- **Severity:** Error
- **Configuration:** Default

### [no-console](https://eslint.org/docs/rules/no-console)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Console logging should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS2228&rule_key=typescript%3AS2228)

### [no-constant-condition](https://eslint.org/docs/rules/no-constant-condition)

- **Severity:** Error
- **Configuration:** Default

### [no-debugger](https://eslint.org/docs/rules/no-debugger)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Debugger statements should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1525&rule_key=typescript%3AS1525)

### [no-dupe-else-if](https://eslint.org/docs/rules/no-dupe-else-if)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Related "if/else if" statements and "cases" in a "switch" should not have the same condition](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1862&rule_key=typescript%3AS1862)

### [no-duplicate-case](https://eslint.org/docs/rules/no-duplicate-case)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Related "if/else if" statements and "cases" in a "switch" should not have the same condition](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1862&rule_key=typescript%3AS1862)

### [no-else-return](https://eslint.org/docs/rules/no-else-return)

- **Severity:** Alert
- **Configuration:** Default

### [no-empty](https://eslint.org/docs/rules/no-empty)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Nested blocks of code should not be left empty](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS108&rule_key=typescript%3AS108)

### [no-empty-character-class](https://eslint.org/docs/rules/no-empty-character-class)

- **Severity:** Error
- **Configuration:** Default

### [no-eval](https://eslint.org/docs/rules/no-eval)

- **Severity:** Error
- **Configuration:** Default

### [no-ex-assign](https://eslint.org/docs/rules/no-ex-assign)

- **Severity:** Error
- **Configuration:** Default

### [no-extend-native](https://eslint.org/docs/rules/no-extend-native)

- **Severity:** Error
- **Configuration:** Default

### [no-extra-boolean-cast](https://eslint.org/docs/rules/no-extra-boolean-cast)

- **Severity:** Alert
- **Configuration:** Default

### [no-floating-decimal](https://eslint.org/docs/rules/no-floating-decimal)

- **Severity:** Alert
- **Configuration:** Default

### [no-implicit-coercion](https://eslint.org/docs/rules/no-implicit-coercion)

- **Severity:** Alert
- **Configuration:** Default

### [no-iterator](https://eslint.org/docs/rules/no-iterator)

- **Severity:** Error
- **Configuration:** Default

### [no-labels](https://eslint.org/docs/rules/no-labels)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Only "while", "do", "for" and "switch" statements should be labelled](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1439&rule_key=typescript%3AS1439)

### [no-lone-blocks](https://eslint.org/docs/rules/no-lone-blocks)

- **Severity:** Alert
- **Configuration:** Default

### [no-loop-func](https://eslint.org/docs/rules/no-loop-func)

- **Severity:** Error
- **Configuration:** Default

### [no-multi-str](https://eslint.org/docs/rules/no-multi-str)

- **Severity:** Alert
- **Configuration:** Default

### [no-new](https://eslint.org/docs/rules/no-new)

- **Severity:** Alert
- **Configuration:** Default

### [no-new-func](https://eslint.org/docs/rules/no-new-func)

- **Severity:** Error
- **Configuration:** Default

### [no-new-wrappers](https://eslint.org/docs/rules/no-new-wrappers)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Wrapper objects should not be used for primitive types](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1533&rule_key=typescript%3AS1533)

### [no-octal-escape](https://eslint.org/docs/rules/no-octal-escape)

- **Severity:** Alert
- **Configuration:** Default

### [no-proto](https://eslint.org/docs/rules/no-proto)

- **Severity:** Error
- **Configuration:** Default

### [no-prototype-builtins](https://eslint.org/docs/rules/no-prototype-builtins)

- **Severity:** Alert
- **Configuration:** Default

### [no-regex-spaces](https://eslint.org/docs/rules/no-regex-spaces)

- **Severity:** Error
- **Configuration:** Default

### [no-return-assign](https://eslint.org/docs/rules/no-return-assign)

- **Severity:** Alert
- **Configuration:** Default

### [no-script-url](https://eslint.org/docs/rules/no-script-url)

- **Severity:** Error
- **Configuration:** Default

### [no-setter-return](https://eslint.org/docs/rules/no-setter-return)

- **Severity:** Alert
- **Configuration:** Default

### [no-shadow-restricted-names](https://eslint.org/docs/rules/no-shadow-restricted-names)

- **Severity:** Error
- **Configuration:** Default

### [no-unexpected-multiline](https://eslint.org/docs/rules/no-unexpected-multiline)

- **Severity:** Error
- **Configuration:** Default

### [no-unreachable-loop](https://eslint.org/docs/rules/no-unreachable-loop)

- **Severity:** Error
- **Configuration:** Default

### [no-useless-backreference](https://eslint.org/docs/rules/no-useless-backreference)

- **Severity:** Alert
- **Configuration:** Default

### [no-useless-call](https://eslint.org/docs/rules/no-useless-call)

- **Severity:** Alert
- **Configuration:** Default

### [no-useless-concat](https://eslint.org/docs/rules/no-useless-concat)

- **Severity:** Alert
- **Configuration:** Default

### [no-useless-escape](https://eslint.org/docs/rules/no-useless-escape)

- **Severity:** Alert
- **Configuration:** Default

### [no-useless-return](https://eslint.org/docs/rules/no-useless-return)

- **Severity:** Alert
- **Configuration:** Default

### [no-var](https://eslint.org/docs/rules/no-var)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Variables should be declared with "let" or "const"](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3504&rule_key=typescript%3AS3504)

### [no-void](https://eslint.org/docs/rules/no-void)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "allowAsStatement": true
    }
]
```

### [no-warning-comments](https://eslint.org/docs/rules/no-warning-comments)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "terms

        todo", "fixme"]

    }
]
```

### [prefer-const](https://eslint.org/docs/rules/prefer-const)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Unchanged variables should be marked "const"](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3353&rule_key=typescript%3AS3353)

### [prefer-destructuring](https://eslint.org/docs/rules/prefer-destructuring)

- **Severity:** Alert
- **Configuration:** Default

### [prefer-promise-reject-Errors](https://eslint.org/docs/rules/prefer-promise-reject-Errors)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "allowEmptyReject": true
    }
]
```

### [prefer-template](https://eslint.org/docs/rules/prefer-template)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Template strings should be used instead of concatenation](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3512&rule_key=typescript%3AS3512)

### [require-unicode-regexp](https://eslint.org/docs/rules/require-unicode-regexp)

- **Severity:** Alert
- **Configuration:** Default

### [require-yield](https://eslint.org/docs/rules/require-yield)

- **Severity:** Alert
- **Configuration:** Default

### [sonarjs/cognitive-complexity](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/cognitive-complexity.md)

- **Severity:** Error
- **Configuration:**

```json
[30]
```

> Anticipates Sonar rule [Cognitive Complexity of functions should not be too high](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3776&rule_key=typescript%3AS3776)

### [sonarjs/no-all-duplicated-branches](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-all-duplicated-branches.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [All branches in a conditional structure should not have exactly the same implementation](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3923&rule_key=typescript%3AS3923)

### [sonarjs/no-collapsible-if](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-collapsible-if.md)

- **Severity:** Alert
- **Configuration:** Default

### [sonarjs/no-collection-size-mischeck](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-collection-size-mischeck.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Collection sizes and array length comparisons should make sense](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3981&rule_key=typescript%3AS3981)

### [sonarjs/no-duplicated-branches](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-duplicated-branches.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Two branches in a conditional structure should not have exactly the same implementation](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1871&rule_key=typescript%3AS1871)

### [sonarjs/no-element-overwrite](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-element-overwrite.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Collection elements should not be replaced unconditionally](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4143&rule_key=typescript%3AS4143)

### [sonarjs/no-identical-conditions](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-identical-conditions.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Related "if/else if" statements and "cases" in a "switch" should not have the same condition](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1862&rule_key=typescript%3AS1862)

### [sonarjs/no-identical-expressions](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-identical-expressions.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Identical expressions should not be used on both sides of a binary operator](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1764&rule_key=typescript%3AS1764)

### [sonarjs/no-identical-functions](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-identical-functions.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Functions should not have identical implementations](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4144&rule_key=typescript%3AS4144)

### [sonarjs/no-inverted-boolean-check](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-inverted-boolean-check.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Boolean checks should not be inverted](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1940&rule_key=typescript%3AS1940)

### [sonarjs/no-one-iteration-loop](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-one-iteration-loop.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Loops with at most one iteration should be refactored](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1751&rule_key=typescript%3AS1751)

### [sonarjs/no-redundant-boolean](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-redundant-boolean.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Boolean literals should not be redundant](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1125&rule_key=typescript%3AS1125)

### [sonarjs/no-redundant-jump](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-redundant-jump.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Jump statements should not be redundant](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3626&rule_key=typescript%3AS3626)

### [sonarjs/no-small-switch](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-small-switch.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule ["switch" statements should have at least 3 "case" clauses](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1301&rule_key=typescript%3AS1301)

### [sonarjs/no-useless-catch](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/no-useless-catch.md)

- **Severity:** Alert
- **Configuration:** Default

### [sonarjs/prefer-while](https://github.com/SonarSource/eslint-plugin-sonarjs/blob/master/docs/rules/prefer-while.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [A "while" loop should be used instead of a "for" loop](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS1264&rule_key=typescript%3AS1264)

### [wrap-iife](https://eslint.org/docs/rules/wrap-iife)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/adjacent-overload-signatures](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/adjacent-overload-signatures.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Method overloads should be grouped together](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4136&rule_key=typescript%3AS4136)

### [@typescript-eslint/array-type](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/array-type.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "default": "generic"
    }
]
```

### [@typescript-eslint/await-thenable](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/await-thenable.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule ["await" should only be used with promises](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4123&rule_key=typescript%3AS4123)

### [@typescript-eslint/ban-ts-comment](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/ban-ts-comment.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/consistent-type-assertions](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/consistent-type-assertions.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule [Type assertions should use "as"](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4137&rule_key=typescript%3AS4137)

### [@typescript-eslint/default-param-last](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/default-param-last.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/explicit-function-return-type](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/explicit-function-return-type.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/explicit-member-accessibility](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/explicit-member-accessibility.md)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "accessibility": "explicit",
        "ignoredMethodNames": ["constructor"]
    }
]
```

### [@typescript-eslint/explicit-module-boundary-types](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/explicit-module-boundary-types.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-array-constructor](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-array-constructor.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-dupe-class-members](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-dupe-class-members.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-dynamic-delete](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-dynamic-delete.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-explicit-any](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-explicit-any.md)

- **Severity:** Error
- **Configuration:** Default

> Antecipa regras do Sonar [Primitive return types should be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4324&rule_key=typescript%3AS4324) e [The "any" type should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4204&rule_key=typescript%3AS4204)

### [@typescript-eslint/no-floating-promises](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-floating-promises.md)

- **Severity:** Error
- **Configuration:**

```json
[
    {
        "ignoreVoid": true
    }
]
```

### [@typescript-eslint/no-for-in-array](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-for-in-array.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule ["for in" should not be used with iterables](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4139&rule_key=typescript%3AS4139)

### [@typescript-eslint/no-implied-eval](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-implied-eval.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-inferable-types](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-inferable-types.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/no-invalid-this](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-invalid-this.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-magic-numbers](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-magic-numbers.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "ignoreArrayIndexes": true,
        "ignoreDefaultValues": true
    }
]
```

> Anticipates Sonar rule [Magic numbers should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS109&rule_key=typescript%3AS109)

### [@typescript-eslint/no-misused-new](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-misused-new.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Constructors should not be declared inside interfaces](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4124&rule_key=typescript%3AS4124)

### [@typescript-eslint/no-misused-promises](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-misused-promises.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-namespace](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-namespace.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/no-require-imports](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-require-imports.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule ["import" should be used to include external code](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3533&rule_key=typescript%3AS3533)

### [@typescript-eslint/no-this-alias](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-this-alias.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule ["this" should not be assigned to variables](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4327&rule_key=typescript%3AS4327)

### [@typescript-eslint/no-throw-literal](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-throw-literal.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Strings should not be thrown](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS3696&rule_key=typescript%3AS3696)

### [@typescript-eslint/no-unnecessary-condition](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unnecessary-condition.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Conditions should not always evaluate to 'true' or to 'false'](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS2589&rule_key=typescript%3AS2589)

### [@typescript-eslint/no-unnecessary-type-arguments](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unnecessary-type-arguments.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/no-unnecessary-type-assertion](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unnecessary-type-assertion.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/no-unsafe-assignment](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unsafe-assignment.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Primitive return types should be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4324&rule_key=typescript%3AS4324)

### [@typescript-eslint/no-unsafe-call](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unsafe-call.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/no-unsafe-member-access](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unsafe-member-access.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Primitive return types should be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4324&rule_key=typescript%3AS4324)

### [@typescript-eslint/no-unsafe-return](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unsafe-return.md)

- **Severity:** Error
- **Configuration:** Default

> Anticipates Sonar rule [Primitive return types should be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4324&rule_key=typescript%3AS4324)

### [@typescript-eslint/no-unused-vars](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-unused-vars.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/no-useless-constructor](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-useless-constructor.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/no-var-requires](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/no-var-requires.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/prefer-as-const](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-as-const.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/prefer-for-of](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-for-of.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule ["for of" should be used with Iterables](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4138&rule_key=typescript%3AS4138)
>
> benchmark: [teste com ***for*** e ***for of***](https://jsben.ch/uWHON)

### [@typescript-eslint/prefer-function-type](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-function-type.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/prefer-includes](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-includes.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/prefer-literal-enum-member](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-literal-enum-member.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/prefer-namespace-keyword](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-namespace-keyword.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule ["module" should not be used](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4156&rule_key=typescript%3AS4156)

### [@typescript-eslint/prefer-readonly](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-readonly.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/prefer-reduce-type-parameter](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-reduce-type-parameter.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/prefer-regexp-exec](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-regexp-exec.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/prefer-string-starts-ends-with](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/prefer-string-starts-ends-with.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/promise-function-async](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/promise-function-async.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/require-array-sort-compare](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/require-array-sort-compare.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/require-await](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/require-await.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/return-await](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/return-await.md)

- **Severity:** Alert
- **Configuration:** Default

> Anticipates Sonar rule ["await" should not be used redundantly](http://sonarqube-ce.paas.santanderbr.corp/coding_rules?open=typescript%3AS4326&rule_key=typescript%3AS4326)

### [@typescript-eslint/strict-boolean-expressions](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/strict-boolean-expressions.md)

- **Severity:** Error
- **Configuration:** Default

### [@typescript-eslint/switch-exhaustiveness-check](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/switch-exhaustiveness-check.md)

- **Severity:** Alert
- **Configuration:** Default

### [@typescript-eslint/triple-slash-reference](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/triple-slash-reference.md)

- **Severity:** Alert
- **Configuration:**

```json
[
    {
        "types": "prefer-import"
    }
]
```

### [@typescript-eslint/unified-signatures](https://github.com/typescript-eslint/typescript-eslint/blob/master/packages/eslint-plugin/docs/rules/unified-signatures.md)

- **Severity:** Error
- **Configuration:** Default
