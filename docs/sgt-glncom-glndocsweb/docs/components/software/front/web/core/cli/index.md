# Santander CLI

The goal of this library is to provide a CLI to generate the boilerplate code for Santander projects and other utilities to help the development.

## Install

Install the CLI:

```bash
npm install -g @santander/cli
```

## Usage

### Generate a new project

To generate a new project, run the following command:

```bash
gln new <project-name> --projectType=<project-type>
```

The `project-type` can be one of the following:

- `angular-darwin-application`: Generates a new Angular application using the Darwin architecture.
- `angular-darwin-mfe`: Generates a new Angular micro frontend using the Darwin architecture.
- `angular-afe-application`: Generates a new Angular application using the AFE architecture.
- `angular-afe-mfe`: Generates a new Angular micro frontend using the AFE architecture.
- `react-none-application`: Generates a new React application.
