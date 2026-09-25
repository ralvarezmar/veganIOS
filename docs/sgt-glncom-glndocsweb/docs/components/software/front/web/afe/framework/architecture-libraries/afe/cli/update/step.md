# Selecting Upgrade Steps

This session aims to instruct the use of the 'afe update' command to perform specific steps of the update in isolation through the '--step' parameter.

Due to scenarios where errors occur during the update at a certain step of the process, through the following command:

``` BASH
afe update --step=<NOME_DA_ETAPA> --type=<TIPO_DO_PROJETO>
```

Where the following values should be replaced with:

Parameter | Replacement
--------- | -----------
**`<NOME_DA_ETAPA>`** | specific step that will be performed in isolation;
**`<TIPO_DO_PROJETO>`** | project type (***application***, ***element*** or ***library***).

For the **available steps** for updating your project, see **[list of available steps](./steps.md)**.
