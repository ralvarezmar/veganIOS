# Connectivity Gluon Runners

## Overview

This repository: [gln-test-connectivity-devops](https://github.com/santander-group-sds-gln/gln-test-connectivity-devops) contains several GitHub Actions workflows that are designed to help manage and debug your GitHub Actions runners.

Below is a brief description of each workflow and links to detailed documentation.

1. [Runner Tools List](https://github.com/santander-group-sds-gln/gln-test-connectivity-devops/blob/main/RUNNER-TOOLS-LIST.md)
   This workflow lists all the tools installed on a specific runner. It is useful for debugging and maintaining GitHub runners.

2. [Runner Packages List](https://github.com/santander-group-sds-gln/gln-test-connectivity-devops/blob/main/RUNNER-PACKAGES-LIST.md)
   This workflow is designed to list the packages installed on a specified GitHub Actions runner.
   It can be manually triggered and accepts two inputs: `runner_label` and `custom_runner_label`.
   The `make-mirror` job runs a shell script that uses `rpm -qa` command to list all installed packages on the runner.

3. [Runner Test Connectivity](https://github.com/santander-group-sds-gln/gln-test-connectivity-devops/blob/main/RUNNER-TEST-CONNECTIVITY.md)
   This workflow is designed to test the connectivity from a specified GitHub Actions runner to a specified server.
   It can be manually triggered and accepts two inputs: `runner_label` and `server_url`.
   The `make-test` job runs a shell script that uses `ping` command to test the connectivity.

## Permission in repository

To grant yourself write permissions in the repository, follow the actions described in this [Process Add Users Issues Workflow](https://github.com/santander-group-sds-gln/gln-test-connectivity-devops/blob/main/README_process_issues.yaml)

This repository contains an automated system to manage access requests to the GitHub repository `santander-group-sds-gln/gln-test-connectivity-devops`. Users can create issues to request adding users to this repository with write permissions.

A workflow runs every 30 minutes to process pending issues and grant the requested access.. It can also be triggered manually.

Please refer to the individual markdown files for more detailed information on each workflow, including their triggers, inputs, jobs, and usage.
