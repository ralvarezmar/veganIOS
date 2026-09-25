# Missing x-encrypted-object header

## Contextualization

Service call failed due to missing header ***x-encrypted-object***

## Architecture Guidelines

On the part of the frontend architecture, we do not perform any management that adds the header in question to the request made by the application.

This header is usually passed by the old ***HUB Services (ZUP)*** when configured by the APP in the project's own ZUP, then extracting the ***ticket*** pertinent to the exchange of keys provided by the web application that made the request.

In this regard, we advise you to contact ***[Integration Architecture (CoG)](https://confluence.santanderbr.corp/display/PADROESARQINT)*** for more details and guidance on identifying the absence of the header.
