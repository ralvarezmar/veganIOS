# Changing attributes of tokens managed by @afe/authentication

## Contextualization

Guidance regarding adding or changing attributes (***claims***) of tokens pertinent to the ***OAuth2*** flow for communication with the new ***gateway*** of services (***APIGEE***)

## Architecture Guidelines

In ***@afe/authentication*** AFE **does not make** any changes to the tokens returned by the services HUB, the piece only ends up managing the authentication process and the management of the tokens.

Providing the ability to use authorization in calls to APIs in APIGEE.

Basically, what we receive from the authentication flow is sent to the gateway for the purpose of refreshing the access token, maintaining the channel's ability to call an API and not result in the lack of permission.

After the ***access_token*** expiration period.

To identify the change of any ***claim*** of the tokens pertinent to the ***OAuth2***, we advise you to contact ***[Integration Architecture (CoG)](https://confluence.santanderbr.corp/display/PADROESARQINT)*** to analyze the problem.
