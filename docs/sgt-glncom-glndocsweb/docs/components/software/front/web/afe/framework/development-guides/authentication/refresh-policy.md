# Session Update Policy

Refresh is the process of renewing the ***access_token***.

Which has a certain expiration time and must be exchanged when it expires. This update occurs through a new request to the HUB using the ***refresh_token*** that came in the authentication performed, and through this new request, new tokens will be returned.

This process occurs automatically, so that every time it reaches 75% of the ***access_token*** expiration time, a new update will occur, excluding the possibility of any call using an ***token*** that has already expired.

As of version ***1.2.0*** of the piece, a new policy has been added, allowing the ability to monitor the user's interaction with the application through events, so that if inactivity (idleness) is identified after a certain time.

It interrupts the automated process of token refresh. To do this, you need to set the ***idleTimeout*** property in the configuration file used in the part module.

When the value ***true*** is passed to the ***idleTimeout*** property.

The monitoring policy will be used and the library will monitor the user's idleness in the application based on the expiration time of the ***refresh_token*** returned by the gateway in the authentication response.

It is possible to enter a numerical value (in milliseconds) corresponding to the desired threshold time for idle monitoring.

If the value ***600000*** is passed, it means that in the ***10 minutes*** time window, if no interaction with the application occurs, the automated token refresh process will be interrupted. If an interaction happens, the policy monitoring time is restarted.

> ❗**Remarks**
>
> Although the property is optional, we advise the inclusion as it corrects an EHT point.
>
> Versions prior to ***1.2.0***, use a ***deprecated*** policy and should not be used as it has vulnerabilities that lead to security and EHT issues.
