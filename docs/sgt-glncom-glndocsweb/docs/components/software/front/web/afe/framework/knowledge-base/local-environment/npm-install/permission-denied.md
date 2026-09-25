# How to troubleshoot permission issues when running `npm install` command?

## Contextualization

When executing the 'npm install' command, an error occurs indicating a permission problem, and this scenario can happen in any dependency of the project, so the problem will contain in its description the following warning:

```bash
Error: EPERM: Operation not permitted, unlink (ou lstat) '..\project-name\node_modules\.staging\dependency-name'
```

## Solution

- Look in the console log for the word **corrupted** and install the associated dependency separately, if you identify more than one occurrence, perform the separate execution on each one... The warning will look like the line below.

```bash
tarball tarball data for typescript@3.2.4 (sha1-xYXLlSkSJj2RW0YnJs4kS6UQ7z0=) seems to be corrupted. Trying one more time.
```

- Run the 'npm install' command only on the mentioned dependency, for example: 'npm i typescript@3.2.4'.
- Resume running the 'npm install' command, most likely the installation will complete normally.
  - If the error persists, review the procedure, as this time the problem must be associated with another dependency.

> **Note:**
>
> We recommend that you follow our [documentation for anti-virus release](../antivirus.md), via a request in ***service now*** to configure an antivirus rule pertinent to the ***node_modules*** folder.

## Alternatives

If by any chance the above steps don't work, try the options below:

### Removal of ***package-lock.json***

- Delete the ***package-lock.json*** file located at the root of the project.

### Clean up ***npm*** and ***npm-cache***

- Delete the ***npm-cache*** and ***npm*** folders located in the paths below from the root of your user in C:\Users\MATRICULA
  - .\AppData\Roaming\npm-cache
  - .\AppData\Roaming\npm\node_modules\npm
- Restart the machine and run the following commands:
  - `npm cache clean --force`
  - `npm install -g npm@latest --force`
  - `npm cache clean --force`

> For each alternative: resume running npm install on your project.
