# Typescript 4.9

## Operator **_satisfies_**

This new operator solves the inference problem that occurs when using more than one type in a given structure.

The example below demonstrates a scenario of an object that allows receiving the types `string` and `string[]` as a value in each property, meaning that it is not possible to consume the methods of the types `string` and `string[]` directly .

```ts
interface I {
     [key: string]: string | string[]
}

const favoriteColors = {
     value1: '',
     value2: ['']
} as I;

// variable "v" will be typed as "string | string[]"
const v = favoriteColors.value1;

// Error!
// method "endsWith" does not exist in type "string | string[]"
v.endsWith('h');
```

The **_satisfies_** operator solves this inference problem through stricter typing.

```ts
interface I {
     [key: string]: string | string[]
}

const favoriteColors = {
     value1: '',
     value2: ['']
} satisfies I;

// variable "v" will be typed as "string"
const v = favoriteColors.value1;

// method "endsWith" exists on type "string"
v.endsWith('h');
```

> For more information, visit [official documentation on the satisfies operator.](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-9.html#the-satisfies-operator)
