# Typescript 4.7

## Creating specialized types

Added possibility to apply, and reuse, more specialized typing for [functions](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Functions) or [constructors](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes/constructor).

```ts
function foo<T>(value: T) {
     return { value };
}

const stringFoo = foo<string>;

stringFoo('ok') // { ok: 'ok' }
stringFoo(1) // Error! stringFoo only accepts string
```

As mentioned before, you can use this functionality in **constructors** as well.

```ts
const PriceMap = Map<string, number>;

const priceMap = new PriceMap();

priceMap.set('product1', 100);
priceMap.set('product2', '100'); // TypeScript issues an error correctly
```

> For more information, visit [official documentation on specialized types.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html#instantiation-expressions>)

## Configuration **_moduleSuffixes_**

Typescript 4.7 supports the use of suffixes in `.ts` files.

```ts
{
     "compilerOptions": {
         "moduleSuffixes": [".ios", ".native", ""]
     }
}
```

The compiler will check the existence of each file respecting the order in which the suffixes were configured.

For example, using the code `import foo from "./foo";`, the check order to import the file will be:

- `foo.ios.ts`
- `foo.native.ts`
- `foo.ts`

> The value `""` in the moduleSuffixes array is used to map files without a suffix. In this case, `foo.ts`.

This functionality is very useful for projects that use the same code in different environments (such as mobile development).

> For more information, visit [official documentation on modules with suffix.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html#resolution-customization-with-modulesuffixes>)

## Source code view

Allows you to access the source code of any resource being consumed, such as third-party libraries.

This functionality is fully integrated with [Visual Studio Code](https://code.visualstudio.com/).

> For more information, visit [official source code visualization documentation.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html#go-to-source-definition>)

## Ordering of **_imports_** based on groups

The functionality that organizes the _imports_ of previous versions, ordered the _imports_ using the import **path** as a reference, which generated an incorrect ordering at times.

```ts
// Code BEFORE sorting

// local code
import * as bbb from "./bbb";
import * as ccc from "./ccc";
import * as aaa from "./aaa";
// built-ins
import * as path from "path";
import * as child_process from "child_process"
import * as fs from "fs";

// Code AFTER sorting

// local code
import * as child_process from "child_process";
import * as fs from "fs";
// built-ins
import * as path from "path";
import * as aaa from "./aaa";
import * as bbb from "./bbb";
import * as ccc from "./ccc";
```

When ordering grouped code, the ideal is to maintain the grouping. Version v4.7 added this improvement.

```ts
// Code BEFORE sorting

// local code
import * as bbb from "./bbb";
import * as ccc from "./ccc";
import * as aaa from "./aaa";
// built-ins
import * as path from "path";
import * as child_process from "child_process"
import * as fs from "fs";

// Code AFTER sorting

// local code
import * as aaa from "./aaa";
import * as bbb from "./bbb";
import * as ccc from "./ccc";
// built-ins
import * as child_process from "child_process";
import * as fs from "fs";
import * as path from "path";
```

> For more information, access [official documentation on import ordering.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html#group-aware-organize-imports>)

## Auto-complete for methods on objects

Added functionality that _auto completes_, via [IntelliSense](https://code.visualstudio.com/docs/editor/intellisense), methods on objects.

This integration is done natively with [Visual Studio Code](https://code.visualstudio.com).

> For more information, visit [official documentation on auto-complete for methods on objects.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html#object-method-snippet-completions>)

## Add code before the **_super()_** method in the class constructor

JavaScript requires that in _inherited classes_, the `super()` method be called in the constructor before any other code that uses `this`.

TypeScript applies this rule as well, issuing an error when it is not respected. However, in some scenarios, application of the rule is not necessary.

Typescript 4.6 allows the use of code that does not reference `this` before calling the `super()` method.

```ts
class Dog extends Animal {

   constructor() {
     console.log('Run!');
     super();
   }

}
```

> For more information, visit [official documentation on adding codes before the super method.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-6.html#allowing-code-in-constructors-before-super>)

## Use type **_Symbol_** and **_Template String Pattern_** as index in objects

Typescript 4.4 allows you to use:

[Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) and [Template String](<https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals>) Pattern as _index_ of JavaScript objects.

```ts
interface Colors {
   [sym: symbol]: number;
}

let colors: Colors = {};

const red = Symbol("red");

colors[red] = 255;
```

```ts
interface Options {
     width?: number;
     height?: number;
}
let a: Options = {
     width: 100,
     height: 100,
     "data-blah": true,
};
interface OptionsWithDataProps extends Options {
     // Only allow properties that start with 'data-'.
     [optName: `data-${string}`]: unknown;
}
let b: OptionsWithDataProps = {
     width: 100,
     height: 100,
     "data-blah": true,
     // Typescript throws an error
     // because the property is not part of the interface
     // and it also doesn't start with 'data-'
     "unknown-property": true,
};
```

> For more information, access [official documentation on using Symbol and Template String Pattern as index in objects.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-4.html#symbol-and-template-string-pattern-index-signatures>)

## Variable **_error_** typed as unknown in **_Try Catch_**

Version 4.4 changed the type of the **error** variable in **_try/catch_** statements from `any` to `unknown`, when using TypeScript in [strict] mode(<https://www.typescriptlang.org/> tsconfig#strict).

Some errors in your project may occur when performing the migration.

```ts
try {
   executeSomeThirdPartyCode();
} catch (error) { // 'error' is typed as 'unknown
   console.error(err.message); // message does not exist in type unknown
}
```

The error messages you may see in the project are:

```bash
Property 'message' does not exist on type 'unknown'.
Property 'name' does not exist on type 'unknown'.
Property 'stack' does not exist on type 'unknown'.
```

To _workaround_ this problem, it is possible to apply the type `any` to the variable **error**.

```ts
try {
   executeSomeThirdPartyCode();
} catch (err: any) { // 'error' is typed as 'any'
   console.error(err.message); // it works perfectly
}
```

> For more information, access:

[official documentation on the error variable typed as unknown in Try Catch.](<https://www.typescriptlang.org/docs/handbook/release-notes>)

## Different types of values in **_getter_** and **_setter_** properties

TypeScript v4.3 allows getter and setter properties to work with different values.

```ts
class Thing {
   #size = 0;

   get size(): number {
     return this.#size;
   }

   set size(value: string | number | boolean) {
     let num = Number(value);

     if (!Number.isFinite(num)) {
       this.#size = 0;
       return;
     }

     this.#size = num;
   }
}
```

It is important to note that the _setter_ property must use the same type returned in the _getter_ property in at least one of the parameters.

In the code above, `number` is the common type.

> For more information, visit [official documentation on different types of values in getter and setter properties.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-3.html#separate-write-types-on-properties>)

## New **_override_** keyword and flag **_--noImplicitOverride_**

Version 4.3 allows the use of the new `override` _keyword_ when overriding methods in classes derived via inheritance.

This new _keyword_ causes:

- Methods renamed in the base class are reflected in the derived class.
- Overwriting methods by mistake.
- The code becomes more explicit.

It is recommended that the `--noImplicitOverride` flag be enabled so that TypeScript can guarantee the proper functioning of the code.

> For more information, visit [official documentation about the new override keyword and the --noImplicitOverride flag.](<https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-3.html#override-and-the---noimplicitoverride-flag>)
