# Inheritance & Polymorphism (Recommended)

### Inheritance

In an API, there may be model schemas that share common properties. Instead of describing these properties for each schema repeatedly, schemas can be described as a composition of the common property set and schema-specific properties.
OAS3 allows combining and extending model definitions using the following properties of JSON or Schema or YAML, in effect offering model composition.
Inline or referenced schemas MUST be of a Schema Object and not a standard JSON Schema.

- **allOf:**
    Data is validated against all the array of object definitions that are validated independently but together compose a single object.

### Polymorphism

In an API, there may be request and responses can be described by several alternative schemas. To describe these models, oneOf and anyOf properties are used.

- **oneOf:**
        Data is validated against one of the specified schemas.
- **anyOf:**
        Data is validated against ANY amount of the given subschemas. That is, the data may be valid against one or more subschemas at the same time.

While composition offers model extensibility, it does not imply a hierarchy between the models. To support polymorphism, OAS3 adds the support of the "discriminator" field.

- **discriminator:**
    - Property name used to decide which schema definition is used to validate the structure of the model.
    - It MUST be a required field.
    - The value of the chosen property has to be the friendly name given to the model under the definitions property.
    - Inline schema definitions, which do not have a given id, cannot be used in polymorphism.

#### Examples

#### **oneOf**

A pet can only be of one species, in this case, either dog or cat. Every one of it can have different attributes.

```yaml
paths:
  /pets:
    patch:
      requestBody:
        content:
          application/json:
            schema:
              oneOf:
                - $ref: '#/components/schemas/Cat'
                - $ref: '#/components/schemas/Dog'
      responses:
        '200':
          description: Updated
components:
  schemas:
    Dog:
      type: object
      properties:
        bark:
          type: boolean
        breed:
          type: string
          enum: [Dingo, Husky, Retriever, Shepherd]
    Cat:
      type: object
      properties:
        hunts:
          type: boolean
        age:
          type: integer
```

#### **allOf**

This example combines the use of oneOf to tell different pets apart, and the use of allOf to extend the Pet structure to include the specific attributes for every kind of pet.

```yaml
paths:
  /pets:
    patch:
      requestBody:
        content:
          application/json:
            schema:
              oneOf:
                - $ref: '#/components/schemas/Cat'
                - $ref: '#/components/schemas/Dog'
              discriminator:
                propertyName: pet_type
      responses:
        '200':
          description: Updated
components:
  schemas:
    Pet:
      type: object
      required:
        - pet_type
      properties:
        pet_type:
          type: string
      discriminator:
        propertyName: pet_type
    Dog:     # "Dog" is a value for the pet_type property (the discriminator value)
      allOf: # Combines the main `Pet` schema with `Dog`-specific properties
        - $ref: '#/components/schemas/Pet'
        - type: object
          # all other properties specific to a `Dog`
          properties:
            bark:
              type: boolean
            breed:
              type: string
              enum: [Dingo, Husky, Retriever, Shepherd]
    Cat:     # "Cat" is a value for the pet_type property (the discriminator value)
      allOf: # Combines the main `Pet` schema with `Cat`-specific properties
        - $ref: '#/components/schemas/Pet'
        - type: object
          # all other properties specific to a `Cat`
          properties:
            hunts:
              type: boolean
            age:
              type: integer
```

#### **anyOf**

In this example, a pet can be defined both by type (cat or dog) or by age.

```yaml
paths:
  /pets:
    patch:
      requestBody:
        content:
          application/json:
            schema:
              anyOf:
                - $ref: '#/components/schemas/PetByAge'
                - $ref: '#/components/schemas/PetByType'
      responses:
        '200':
          description: Updated
components:
  schemas:
    PetByAge:
      type: object
      properties:
        age:
          type: integer
        nickname:
          type: string
      required:
        - age
    PetByType:
      type: object
      properties:
        pet_type:
          type: string
          enum: [Cat, Dog]
        hunts:
          type: boolean
      required:
        - pet_type
```
