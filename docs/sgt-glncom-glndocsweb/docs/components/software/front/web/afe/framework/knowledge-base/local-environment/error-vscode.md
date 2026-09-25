# How To Troubleshoot Error Running vscode Terminal?

## Contextualization

When running the VsCode terminal, you may encounter the error:

![Image describing the error about problem running terminal in vscode](../../../../images/local-environment/vscode-error.png)

## Solution

The problem can be resolved by adding the following line to the ***settings.json***

```json
"terminal.integrated.windowsEnable": false,
```

![(image demonstrating the solution of the problem when running vscode terminal)](../../../../images/local-environment/solucao-vscode.png)
