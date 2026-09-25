# Placement Engine

## What is Placement Engine?

It is responsible for calculating and validating which resources will be provisioned and where they should be provisioned using a few requesting user variables to make these decisions.

## Placament Diagram

![placament](./images/Placement-process.png)

## When is it started?

The Placement action is located on Terraform Plan step.

## Placement Inputs

The placement engine read the file "values.yml" that is located on .../src/.gluon/cd/<code>environment</code>, which is generated based on the data entered in the Virtual Machine template form in the Gluon UI.

```yaml
# Configuration
santander_cloudprovider: ohe
availability_zone: az1
resourcetype: srv
template: Red Hat Enterprise Linux - LATEST
network_tier: t2
flavor: 4x4

country: "BRA"

amount: 1
acronym: aie
```

## Placement Outputs

When the Terraform Plan workflow is finished, the filen "placement_info.json" is added on .../src/.gluon/cd/<code>environment</code>/.controller, that contains all data generated on placement. Such as:

- Deployment ID
- Parent Account
- Parent Region
- IPs
- Network Name
- Resource Names
- Storage Location
