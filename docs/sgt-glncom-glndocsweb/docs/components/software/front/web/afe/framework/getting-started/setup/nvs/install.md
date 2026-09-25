# Install

Follow the steps outlined according to your operating system.

## MacOS / Linux

Run the command below to set the installation path:

```bash
export NVS_HOME="$HOME/.nvs"
```

Clone the repository via the ***front-end architecture gitlab***:

```bash
git clone https://gitlab.santanderbr.corp/ARQFE/ferramentas/nvs "$NVS_HOME"
```

And finally, run the installation ***script***:

```bash
. "$NVS_HOME/nvs.sh" install
```

## Windows

Download the "script" according to the following link and in the folder where the file is located, in your terminal (PowerShell), run the command:

> If the transfer doesn't initialize automatically, simply save the file with the `.ps1` extension.

- **Install script with PowerShell**: ⬇️ [install-nvs.ps1](https://gitlab.santanderbr.corp/ARQFE/ferramentas/nvs/raw/master/install-nvs.ps1)

```powershell
.\install-nvs.ps1
```

> **Note**: You need to shut down the terminal and launch a new one to validate the change.

It is possible to inform the desired node version to be configured as predefined in each powershell terminal that will be initialized, for this, just inform after the "script", the 'node' parameter and the desired version, for example:

```ps1
.\install-nvs.ps1 -node 14.12.0
```

> Unlike the process carried out on MAC/Linux, which uses the `install` command to configure the NVS path and the execution binary for the user profile.
> On Windows there is a limitation due to the specifications of the policy of restricting registrations on Santander machines, so the "script" in question will perform the following procedures:
>
> - (1) Configures the NVS directory
> - (2) Clone the repository
> - (3) Add as variable in user PATH
> - (4) Creates the logic to load a predefined node version.
