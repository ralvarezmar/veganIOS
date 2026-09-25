---
title: Document Validator
---

## Overview

The `@santander/field-formatter-angular` package provides Angular Service to validate documents according to their type and will return whether the document is valid based on the applied rule. This enhances readability and user experience in Angular applications.

- `DocumentValidatorService`: Provides methods to validate document numbers such as CNPJ, and others.

## Installation

To use these pipes and services in your project, install the packages via npm:

```bash
npm install @santander/field-formatter-angular
```

## How To

### `DocumentValidatorService`

The `DocumentValidatorService` provides methods to validate document numbers such as CNPJ, and others.
It ensures that the provided document numbers conform to the expected format and checksum rules.
This class is already prepared to handle the new rule that will come into effect in 2026, as per the Brazilian government's regulation.
This rule allows **CNPJ** (Cadastro Nacional da Pessoa Jurídica) identifiers to include alphanumeric characters in the first 9 digits.
The library ensures compatibility with this upcoming change, providing seamless validation for both current and future formats.

#### Setup for DocumentValidatorService

```typescript
import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { DocumentValidatorModule } from '@santander/field-formatter-angular';

export const appConfig: ApplicationConfig = {
  providers: [
    // ...existing providers...
    importProvidersFrom(DocumentValidatorModule)
  ]
};
```

#### Usage

To use the `DocumentValidatorService`, inject it into your Angular component or service:

```typescript
import { Component, inject } from '@angular/core';
import { DocumentValidatorService } from '@santander/field-formatter-angular';

@Component({
  selector: 'app-root',
  templateUrl: './app.html',
  styleUrls: ['./app.css']
})
export class AppComponent {
  private documentValidator = inject(DocumentValidatorService);

  validateDocument(document: string, type: string): boolean {
    return this.documentValidator.isValid(document, type);
  }
}
```

### Supported Document Types

The `isValid` method supports the following document types:

- **CNPJ**: Cadastro Nacional da Pessoa Jurídica (Brazil)

### Available Methods

#### `isValid(documentId: string, typeCode: DocumentTypes): boolean`

**Description**: Determines whether a document identifier is valid for the specified type.

**Parameters**:

- `documentId`: The document identifier to be validated.
- `typeCode`: The document type, based on the `DocumentTypes` enum (e.g., 'CNPJ').

**Returns**: `true` if the document is valid, `false` otherwise.

#### Example Usage

```typescript
const isValidCNPJ = this.documentValidator.isValid('12345678000199', 'CNPJ'); // Returns true or false
```

### Examples for CNPJ

| Multiples CNPJs      | Note                    |
| -------------------- | ----------------------- |
| `12ABC34501DE35`     | `OK`                    |
| `1345C3A5000106`     | `OK`                    |
| `R55231B3000700`     | `Wrong check digit`     |
| `1345c3A5000106`     | `Lower case`            |
| `90.021.382/0001-22` | `OK`                    |
| `90.024.778/000123`  | `OK`                    |
| `90.025.108/000101`  | `Wrong check digit`     |
| `90.025.255/0001`    | `Invalid size`          |
| `90.024.420/0001A2`  | `Letter in check digit` |
