# How to troubleshoot "***412 precondition failed***"

## Contextualization

The HTTP client error response code ***412 Precondition Failed*** indicates that access to the specified resource was denied, usually when trying to authenticate to the application with your network username and password in Single Sign-On (SSO).

## Reason

This issue occurs when the enrollment of the user or account of the bank customer who is trying to log in to the service to authenticate via some authenticator service is not released in the governance of the endpoint.

## Solution

As it is an authentication service, the guidance is to look for the [Security Solutions](https://confluence.santanderbr.corp/display/SOLSEG) team so that the registration of the user or client in question is released.
