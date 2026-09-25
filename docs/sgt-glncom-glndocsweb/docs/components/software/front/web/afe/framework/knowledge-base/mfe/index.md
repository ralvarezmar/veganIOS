# Micro front-end

This session is intended to provide guidance for issues encountered during the implementation of micro-front architecture with Angular Elements.

## 🎯 Overview

Errors during micro front-end (MFE) application development can happen due to the following factors:

- Configuration of modules that should only be configured in the shell application and not in MFE applications, which should only consume `Inherited` modules;

## 📋 Initial Checklist

Before proceeding to the mapped scenarios we have documented, follow the checklist to do a recap of the procedure required for developing MFE applications with Angular Elements:

- Make sure you are using the 'Inherited' modules in your Angular Element application, rather than replicating the configurations of the modules that are in the base application.
- Visit the [Angular Elements development guides](../../development-guides/mfe/angular-elements/index.md) and **perform the necessary implementation** from the available tutorials;

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### While the application is running**

Documented possible solutions to this issue are:

- [Application crashing or freezing](./application-locking.md)
