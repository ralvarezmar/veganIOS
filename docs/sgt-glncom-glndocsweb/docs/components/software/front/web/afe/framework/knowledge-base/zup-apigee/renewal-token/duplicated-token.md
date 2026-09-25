# Duplicate renewal token request when re-authenticating

## Reason

Calling of the **Auth Refresh*** in the automated process of the structuring ***@afe/authentication*** being called in a duplicate way when the authentication is redone.

## Contextualization

By performing the authentication and login flow more than once, the entire token management flow is initiated by the structuring ***@afe/authentication***.

After having redone the authentication, the automated process that occurs in the library of calling the request to update the tokens ends up being carried out more than once, generating duplication, which is not the correct flow.

## Solution

Install the updated ***@afe/authentication*** package that fixes the problem mentioned in your project:

```diff
npm i @afe/authentication@^2
```
