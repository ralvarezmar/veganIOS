# No Implicit Dependencies

This rule prohibits the use of dependencies not listed in the project's ***package.json***

For projects of type ***application*** and ***element*** the file ***package.json*** is the one from the root of the repository, but for projects of type ***library*** the path ***projects/[project-name]/package.json*** will be considered

> NOTE: If the ***library*** project uses the ***sub-lib*** concept, the ***package.json*** of each ***sub-lib*** will be considered in the validation

## Rule Details

### Settings

This rule takes as a parameter an object containing the following properties:

- **whitelist:Array\<string> -** List of dependencies that can be ignored in rule validation. NOTE: use only in very specific cases of internal dependencies. Default value ***[]***
- **ignoreUnitTestFiles: boolean -** Indicates whether to skip rule validation in unit test files (***/tests/**.js***, ***/tests/**.ts***, ***.spec.js***, ***.spec.ts***, ***.test.js***, ***.test.ts***). Default value ***true***

### Examples

#### Incorrect Example with Default Settings

```typescript
// "@afe/devkit-lint/no-implicit-dependencies": ["error"]

// app.module.ts
import { NgModule } from '@angular/core'; // Erro na dependência ***@angular/core***

```

```json
// package.json
{
    "dependencies": { },
    "peerDependencies": { }
}
```

#### ✅️ Correct Example with Default Settings

```typescript
// "@afe/devkit-lint/no-implicit-dependencies": ["error"]

// app.module.ts
import { NgModule } from '@angular/core';

```

```json
// package.json
{
    "dependencies": { },
    "peerDependencies": {
        "@angular/core": "^8.0.0 || ^10.0.0"
    }
}
```

#### Incorrect Example with ***whitelist*** defined

```typescript
// "@afe/devkit-lint/no-implicit-dependencies": ["error", { "whitelist": ["internal-dep"] }]

// app.module.ts
import { NgModule } from '@angular/core'; // Erro apenas na dependência ***@angular/core***
import { InternalLibModule } from 'internal-dep';

```

```json
// package.json
{
    "dependencies": { },
    "peerDependencies": { }
}
```

#### ✅️ Incorrect example with ***whitelist*** defined

```typescript
// "@afe/devkit-lint/no-implicit-dependencies": ["error", { "whitelist": ["internal-dep"] }]

// app.module.ts
import { NgModule } from '@angular/core';
import { InternalLibModule } from 'internal-dep';

```

```json
// package.json
{
    "dependencies": { },
    "peerDependencies": {
        "@angular/core": "^8.0.0 || ^10.0.0"
    }
}
```

#### Incorrect example with ***ignoreUnitTestFiles*** defined as ***false***

```typescript
// "@afe/devkit-lint/no-implicit-dependencies": ["error", { "ignoreUnitTestFiles": false }]

// app.module.spec.ts
import { NgModule } from '@angular/core'; // Erro na dependência ***@angular/core***

describe('...', () => {

});
```

```json
// package.json
{
    "dependencies": { },
    "peerDependencies": { }
}
```

#### ✅️ Correct example with ***ignoreUnitTestFiles*** defined as ***false***

```typescript
// "@afe/devkit-lint/no-implicit-dependencies": ["error", { "ignoreUnitTestFiles": false }]

// app.module.spec.ts
import { NgModule } from '@angular/core';

describe('...', () => {

});
```

```json
// package.json
{
    "dependencies": { },
    "peerDependencies": {
        "@angular/core": "^8.0.0 || ^10.0.0"
    }
}
```
