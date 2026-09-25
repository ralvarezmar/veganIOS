# Upgrading a project to Angular 8

Go to the root of your project and run the command below, replacing `<PROJECT_TYPE>` with the type of the project that will be migrated. If you don't have this knowledge, check the ***type*** property in ***afe.json***.

```bash
afe update --type=<PROJECT_TYPE>
```

> Make sure that the ***name*** property on the ***package.json*** is the same as the ***defaultProject*** property on the ***angular.json***.
>
> If they differ, add the '--projectName=<DEFAULT_PROJECT_NAME>' parameter to the command that will be executed, where '<DEFAULT_PROJECT_NAME>' should be changed by the value of the ***defaultProject*** property.

You will be asked the following question:

```bash
Do you want to install the project's dependencies after performing the update (npm install)? › (y/N)
```

after answering, a new one will introduce itself:

```bash
Do you want to commit the changes that will be made during the update? › (y/N)
```

Once the questions are answered, the process of migrating your application will begin.

Wait for the command to run. In the end, if no bugs are thrown, your application will have been successfully updated!

> **Attention**
>
> If any step fails, **review the execution log** and **query** in the knowledge base [**problems encountered during the Angular upgrade**](../../knowledge-base/obsolescence/index.md).
