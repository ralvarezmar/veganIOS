---
title: Document Validator
---
## @santander/field-formatter

## Overview

The `@santander/field-formatter` library in JavaScript/TypeScript provides functions to validate documents according to their type. It will return whether the document is valid based on the applied rule.

## Installation

To use these pipes in your project, follow the steps below:

```bash
npm install @santander/field-formatter
```

## `DocumentValidator`

The `DocumentValidator` class is already prepared to handle the new rule that will come into effect in 2026, as per the Brazilian government's regulation.
This rule allows **CNPJ** (Cadastro Nacional da Pessoa Jurídica)
identifiers to include alphanumeric characters in the first 9 digits. The library ensures compatibility with this upcoming change, providing seamless validation for both current and future formats.

### Available Methods

#### `isValid(documentId: string, typeCode: DocumentTypes): boolean`

**Description**: Determines whether a document identifier is valid for the specified type.

**Parameters**:

- `documentId`: The document identifier to be validated.
- `typeCode`: The document type, based on the `DocumentTypes` enum (e.g., `'CNPJ'`).

The `DocumentValidator` currently supports the following document types:

- **CNPJ**: Cadastro Nacional da Pessoa Jurídica (Brazil)

**Returns**: `true` if the document is valid, `false` otherwise.

### How To

#### Import the `DocumentValidator` Class

In your Angular service or component, import the `DocumentValidator` class and the `DocumentTypes` enum:

```typescript
import { DocumentValidator } from '@santander/field-formatter';
import { DocumentTypes } from '@santander/field-formatter';
```

#### Create an Instance of `DocumentValidator`

You can create an instance of the `DocumentValidator` class in your service or component:

```typescript
const documentValidator = new DocumentValidator();
```

#### Validate a Document

Use the `isValid` method to validate a document by providing the document ID and its type:

```typescript
const documentId = '12345678000195'; // Example CNPJ
const isValid = documentValidator.isValid(documentId, DocumentTypes.CNPJ);

console.log(isValid); // true or false
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

### Example Usage in an Angular Project

[Use it in Angular](./use-it-in-angular.md)
