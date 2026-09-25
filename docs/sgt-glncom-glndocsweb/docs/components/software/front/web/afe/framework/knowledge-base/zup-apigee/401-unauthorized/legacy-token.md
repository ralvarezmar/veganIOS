# Coexistence API consumption in v2 using v1 Legacy Token

## Reason

Request made to the Coexistence API in **version 2** being populated with the ***Legacy Token*** instead of the rolling token of ***ZUP***.

## Contextualization

Some projects need to make a change in order for the project to consume the ***v2*** of the ***API*** of coexistence. In this process.

It may happen that the request returns with ***status 401***, because a **Legacy Token** is being used, instead of ***ZUP***'s ***Rolling Token***.

## Solution

With the move to ***v2***, the entire structure of ***APIS*** with ***-leg*** and ***SSO*** in ***v6*** is no longer necessary.

Update the SSO API to the version that your project was previously using before coexistence or to the most current version that is not tied to coexistence.

Also update the encryption API without the ***-leg*** for your project to succeed in **Coexistence Login**.

> **Note**
>
> Also check the documentation regarding [Coexistence between Zup and Apigee](../../../development-guides/authentication/index.md) to learn about the other issues associated with the flow of coexistence.
