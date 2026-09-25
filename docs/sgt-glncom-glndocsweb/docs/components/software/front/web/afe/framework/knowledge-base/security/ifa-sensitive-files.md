# How to solve "IFA (Sensitive Files Disclosure)

## Contextualization

The IFA (Internet Firewall Application) is a specific firewall, designed to protect computer networks from threats by acting as a barrier between the local network and the internet.
Controlling incoming and outgoing traffic following a set of predefined rules.

## Problem

The issue occurs when a potentially sensitive file has been discovered on the Web server. This file may or may not be directly associated with the web application.

Check out the scanned files:

- nginx.conf;
- .htpasswd;
- key.pem;
- the QID Certificate.pem detection logic: This QID sends a GET request to the target server to retrieve the contents of the file.

## Solution

To avoid this issue, you need to follow the guidance in Confluence to perform [API ONBOARDING in WAF](https://confluence.santanderbr.corp/pages/viewpage.action?spaceKey=WAF&title=WAF+-+Como+Realizar+ONBOARDING+de+IFAs+no+WAF+-+PASSO+A+PASSO).
