# Order Imports

This rule encourages the sorting of imports alphabetically both by the import path and the members of each import

> This rule is automatically fixed by using the ***--fix*** option from the [command line](https://eslint.org/docs/user-guide/command-line-interface#fixing-problems)

## Rule Details

### Settings

This rule takes as a parameter an object containing the following properties:

- **ignoreCase: boolean -** Indicates that case-sensitivity can be disregarded in import members. Default value ***false***
- **ignoreDeclarationSort: boolean -** Indicates that declaration validation of imports with disordered paths can be disregarded. Default value ***false***
- **ignoreMemberSort: boolean -** Indicates that validation of unordered import members can be disregarded. Default value ***false***
- **allowSeparatedGroups: boolean -** Indicates that validation can be done between declarations of imports in the same group, i.e., without separating by line break. Default value ***false***

### Examples

#### Incorrect Example with Default Settings

```typescript
// "@afe/devkit-lint/order-imports": ["error"]

// app.module.ts
import { a, A } from 'a'; // Erro no membro ***A*** por estar fora de ordem

import { D } from 'd'; // Erro na declaração inteira por estar fora de ordem dentre todos os imports

import { C } from 'c';
import { B } from 'b'; // Erro da declaração inteira por estar fora de ordem no grupo

import { G, F, E } from 'efg'; // Erro nos membros ***F*** e ***E*** por estarem fora de ordem
```

#### Correct example with default configuration

```typescript
// "@afe/devkit-lint/order-imports": ["error"]

// app.module.ts
import { a, A } from 'a';


import { B } from 'b';
import { C } from 'c';

import { D } from 'd';

import { E, F, G } from 'efg';
```

#### Incorrect example with ***ignoreCase*** defined as ***false***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "ignoreCase": false }]

// app.module.ts
import { a, A } from 'abc'; // Erro no membro ***A*** por estar fora de ordem

```

#### Correct example with ***ignoreCase*** defined as ***true***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "ignoreCase": true }]

// app.module.ts
import { a, A } from 'a';

```

#### Incorrect example with ***ignoreDeclarationSort*** defined as ***false***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "ignoreDeclarationSort": false }]

// app.module.ts
import { B } from 'b';
import { A } from 'a'; // Erro da declaração inteira por estar fora de ordem no grupo

```

#### Correct example with ***ignoreDeclarationSort*** defined as ***true***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "ignoreDeclarationSort": true }]

// app.module.ts
import { B } from 'b';
import { A } from 'a';

```

#### Incorrect example with ***ignoreMemberSort*** defined as ***false***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "ignoreMemberSort": false }]

// app.module.ts
import { B, A } from 'a'; // Erro no membro ***A*** por estar fora de ordem

```

#### Correct example with ***ignoreMemberSort*** defined as ***true***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "ignoreMemberSort": true }]

// app.module.ts
import { B, A } from 'a';

```

#### Incorrect example with ***allowSeparatedGroups*** defined as ***false***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "allowSeparatedGroups": false }]

// app.module.ts
import { B } from 'b';
import { C } from 'c';

import { A } from 'a'; // Erro na declaração inteira por estar fora de ordem dentre todos os imports

```

#### Correct example with ***allowSeparatedGroups*** defined as ***true***

```typescript
// "@afe/devkit-lint/order-imports": ["error" , { "allowSeparatedGroups": true }]

// app.module.ts
import { B } from 'b';
import { C } from 'c';

import { A } from 'a';

```
