# Workspace Configuration

## Software

All applications that are carried out by the Front-End Architecture team are required to use some ***software***. It is necessary to request the installation of some programs that help in the development, such as:

- [Node.js](https://nodejs.org/en/)
- [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/).

> **⚠️ Attention!**
>
> The installation of the ***software*** mentioned above must be carried out by following the steps below:

Remember that when requesting the installation it is necessary that all programs are installed locally, because if it is installed through virtualization, some problem may occur.

## Install Git

The first step is to install ***Git***, the installation must be done by [É Comigo Tecnologia](https://santander.service-now.com/tecnologia).

Search for **Software Request - Licensed and Unlicensed** and fill in the required fields, or the installation can be performed by the Software Center.

## Disable SSL in Git

With Git installed, disable SSL, otherwise you will have certificate issues.

Use the following command below to disable ***SSL*** in ***Git***:

```bash
git config --global http.sslverify false
```

## Install Visual Studio Code

Once the installation of ***Git***, now you need to install ***Visual Studio Code***, the installation can be done by the **Software center** application installed on your machine and also by [É Comigo Tecnologia](https://santander.service-now.com/tecnologia).

> **⚠️ Attention!**
>
> The next step will be to configure [***NVS***](./nvs/index.md), which will be responsible for making the ***NODE***.
