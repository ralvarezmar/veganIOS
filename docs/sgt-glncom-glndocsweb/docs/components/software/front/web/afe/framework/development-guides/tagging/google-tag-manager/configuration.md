# Tagging Library Configuration

## Installation

Install the tagging library using the command:

```bash
npm install @afe/tagging@^4
```

## Configuration

Create a file named ***tagging.config.ts*** that exports a configuration object

``` TS
//tagging.config.ts
import { TaggingConfig } from '@afe/tagging';
import { TaggingGtmConnector } from '@afe/tagging/gtm-connector';

export const taggingConfig: TaggingConfig = {
    connectors: [
        TaggingGtmConnector,
    ],
};
```

And configure the ***TaggingModule*** in the main module of your application with the created configuration object being passed to ***forRoot***.

``` TS
app.module.ts
import { NgModule } from '@angular/core';
import { TaggingModule } from '@afe/tagging';
import { taggingConfig } from '<caminho-do-arquivo-de-configuração>/tagging.config';

@NgModule({
    imports: [
        TaggingModule.forRoot(taggingConfig),
    ],
})
```
