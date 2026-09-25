# **Gluon HowTos**

## **1. How to configure an environment in a github repository**

You can configure environments with protection rules and secrets.
A workflow job that references an environment must follow any
protection rules for the environment before running or accessing
the environment's secrets.

To register an **"environment"** we will need to be administrators
of the repository to access to the settings tab.

- We access **settings / environments** and in this tab we can register it

- Once the environment is created we can:

    1. Configure the reviewers that can approve the deployment.
    2. Limit the use of branches.
    3. Add secrets that can only be used with this environment.

In the case that we have configured a reviewer when the deployment is
executed in the given environment registration, the workflow will stop until
the authorized user approves the deployment. Only authorized reviewers
can approve the deployment.

## **2. Secrets in github.com**

We have three types of secrets:

- Organization secrets: These secrets are created and managed by
the organization administrators.

- Repository secrets: These secrets are created and managed by
the repository administrators.

- Environment secrets: These secrets are created and managed by
the repository administrators or specific reviewers.

## **2.1 How to register a secret in a github.com repository**

To register a secret in a repository and that it can be consumed from
the Gluon workflows, we will follow the next steps.

- In order to carry out the operation we must have admin permissions
    in the repository.

- Then we will go to the **settings** tab, to the **Secrets** menu.

- We will select the option **New repository secret**.

- And finally we add the secret that we need to register.

## **2.2 How to register a secret in a github.com environment**

To register a secret in a specific environment and that it can be consumed from
the Gluon workflows, we will follow the next steps.

- In order to carry out the operation we must have admin permissions
    in the repository or being a reviewer of an created environment.

- Then we will go to the **settings** tab, to the **Environments** menu.

- We will select the desired environment for example
**production**.

- And finally we add the secret that we need to register in the section
that says **Environment secrets**.

## **3. How to skip the execution of a workflow**

It is possible to skip executions of a workflow that is triggered by
push or pull_request events by including a command when committing

For this it will be necessary to add any of the following strings in the
commit

- \[skip ci\]
- \[ci skip\]
- \[no ci\]
- \[skip actions\]
- \[actions skip\]

## **4. How to temporarily disable/enable a workflow**

Sometimes it can be useful for us to temporarily disable some of
the workflows that we have registered in our repository.

To do this, within \"Actions\", we will select the workflow, and in the
3 dots on the right we will select the option **\"Disable Workflow\"**.

Once disabled, a different icon will appear than the rest.

To enable it again, we will select the workflow and click on the option
**\"Enable Workflow\"**.
