# Access Management journey: Vault Interaction

!!! note

    Access Managemenr are the only ones with permissions to create secrets per company and environment and these are the steps that should be follow in order to interact with Vault.

There are 3 Access Management groups created in the Company Onboarding process by entity, one per environment. Find below an example:

- Team_DEV => Example: GR_ALMNXTGN_GLNSDS_DEVAM_DEV
- Team_PRE => Example: GR_ALMNXTGN_GLNSDS_DEVAM_PRE
- Team_PRO => Example: GR_ALMNXTGN_GLNSDS_DEVAM_PRO

During the Onboarding process, the entities are the ones responsible to communicate who are going to be the Unit Owners, who are going to be responsible of the user administration on these Access Management groups through OHE_PORTAL.

Actions that can be made by Access Management in Vault:

- Download Vault client in order to operate with it, following [this instructions](../../how-to/index.md#download-vault-client-in-order-to-operate-with-it)

- Listing secrets through the command line in Vault UI, as mention in [here](../../how-to/index.md#listing-secrets-through-the-command-line-in-vault-ui)

- Create and update Deployment and Application Secrets [here](../../how-to/index.md)

Path accessible to the Access Management group, each one of them to their specific company and environment:

=== "Paths"

```txt
<company>/ci-tools/<environment>/quality/
<company>/ci-tools/<environment>/security-sdlc/
<company>/ci-tools/<environment>/artifact-management/
<company>/<environment>/deployment/
<company>/<application>/ci-tools/<environment>/quality/
<company>/<application>/ci-tools/<environment>/security-sdlc/
<company>/<application>/ci-tools/<environment>/artifact-management/
<company>/<application>/<environment>/application/
<company>/<application>/<environment>/deployment/
```
