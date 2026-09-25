# Declaration of environment variables

Inside the **OPENSHIFT** folder, there are 3 subfolders: **DEV, PRE, and PRO**.

Each folder corresponds to a specific environment. Inside each of them there will be a file called ***env.conf***, where the variables and their respective values for each ***environment***.

> If the ***OPENSHIFT*** folder does not exist, it is necessary to run the project for the first time on the conveyor belt for it to be created or generate the application via **developer portal**.

- **DEV**: development environment;
- **PRE**: HK environment;
- **PRO**: production environment;

> **❗ Information**
>
> The ***env.conf*** file already has some variables created by default (e.g. ***APP_NAME***, ***ENVIRONMENT*** and ***PROJECT_NAME***). You can create as many variables as you need, always remembering to make a line break between each of them.

## Development

To set the value of the ***HUB_HOST*** variable in the **development environment**, we will change the ***env.conf*** file inside the ***DEV*** folder, adding the ***HUB_HOST*** variable and assigning it the value ***<https://esbapi.isbanbr.dev.corp>***.

File: OPENSHIFT/dev/env.conf

``` BASH
HUB_HOST=https://esbapi.isbanbr.dev.corp
```

## HK

To set the value of the ***HUB_HOST*** variable in the **HK environment**, we will change the ***env.conf*** file inside the ***PRE*** folder, adding the ***HUB_HOST*** variable and assigning it the value ***<https://esbapi.santanderbr.pre.corp>***.

File: OPENSHIFT/pre/env.conf

``` BASH
HUB_HOST=https://esbapi.santanderbr.pre.corp
```

## Production

And finally, in order to set the value of the ***HUB_HOST*** variable in the **production environment**, we will change the ***env.conf*** file inside the ***PRO*** folder, adding the ***HUB_HOST*** variable and assigning it the value ***<https://esbapi.santander.com.br>***.

File: OPENSHIFT/pro/env.conf

``` BASH
HUB_HOST=https://esbapi.santander.com.br
```
