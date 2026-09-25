### **Parametric APIs**

In some APIs, there are input parameters that do not usually change, but they may have a certain variability of change.

Depending on the volatility of these parameters, two options are defined:

### Low probability of change

The values ​​of the parameters must be included in the API documentation (yaml or API Portal), identifying the valid values ​​for each use case. E.g. types of documents

#### Example

To execute a specific operation it may be necessary to specify a document number and document type. Types of documents do not usually change, so they can be informed as enums with additional information if required in the parameter description.

```yaml
Document-Type:
    name: "Document-Type"
    type: "string"
    required: true
    in: "header"
    description: "Official document that uniquely identifies a customer before authorities. For legal person, only tax_id is a valid value."
    enum :
    - national_id_card
    - passport
    - childs_id_card
    - social_security_number
    - foreign_resident_id_card
    - driving_license_number
    - tax_id
    example: "tax_id"
```

### High probability of change

A parametric API that provides the values must be provided. In this case, the APIs that need these parameters must include a reference to the parametric API to be self contained. E.g. types of card locks.

#### Example

When unlocking a card, it is mandatory to include in the request the card block that we want to unlock. This information has to be available in a parametric API that has to be used to retrieve the code which has to be in the payload of the unlock request.

```yaml
CardBlockType:
    name: "cardBlockType"
    type: "string"
    required: false
    description: "Type of card lock. Card locks code can be checked at:
                - GET https://gluonmarketplace.com/card_blocks"
    example: "0001"
```
