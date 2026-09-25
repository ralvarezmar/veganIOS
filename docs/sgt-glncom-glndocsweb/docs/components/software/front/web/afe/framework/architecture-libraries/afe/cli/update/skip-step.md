# Skipping Upgrade Steps

This session aims to instruct the project to skip one or more steps in the update process, via the '--skipStep' parameter of the 'afe update' command, via the following command:

``` BASH
afe update --type=<TIPO_DO_PROJETO> --skipStep=<NOME_DA_ETAPA>,<NOME_DA_ETAPA>
```

Where the following values should be replaced with:

Parameter | Replacement
--------- | ------
**`<NOME_DA_ETAPA>`** | step that will be skipped
**`<TIPO_DO_PROJETO>`'** | project type (***application***, ***element*** or ***library***).

For the **available steps** for updating your project, see **[list of available steps](./steps.md)**.
