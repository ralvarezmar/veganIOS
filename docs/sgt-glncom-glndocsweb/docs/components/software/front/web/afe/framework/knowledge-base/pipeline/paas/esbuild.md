# How to troubleshoot the error "Failed to find package "@esbuild/linux-x64" on the file system"

## Contextualization

In the **deploy** step of applications that are on **version 16 of Angular**, the error **"Failed to find package "@esbuild/linux-x64" on the file system** may occur.

This error occurs from the 'npm ci --verbose' command that is contained in the project's ***Dockerfile*** file.

This command installs the project dependencies from the ***package-lock.json*** file, so if the dependency tree is corrupted or outdated, the error will occur as shown in the image above.

> **Note**
>
> Make sure the Dockerfile is configured correctly. You can check the [Configuring Dockerfile](https://afe.paas.santanderbr.pre.corp/docs/angular/guias/deployment/setup/dockerfile) documentation for more information.

## Solution

### Update NPM Benchmarks

- Delete the ***node_modules*** folder;
- Delete the ***package-lock.json*** file.

If you're using MacOS or Git Bash, you can perform the operation with the command:

```bash
rm -rf node_modules package-lock.json
```

If you're using Powershell on Windows, run:

```powershell
rm -Force -Recursive ./node_modules/ ./package-lock.json
```

Once the files have been deleted, you need to install them again. To do this, simply open the **terminal** and run:

```bash
npm install
```

> 💡 Curiosity
>
> When we delete the **node_modules** and **package-lock.json** and run **npm install** again, we reset the project state and allow **npm** to rebuild the dependency tree from scratch.
