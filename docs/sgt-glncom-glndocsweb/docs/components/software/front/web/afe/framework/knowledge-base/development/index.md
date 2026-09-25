# **Development** Knowledge Base

Session created in order to document all errors already recorded on the topic of **development**.

## 🎯 Overview

Development-related errors can arise for a variety of reasons:

- Implementation of code that generates [circular dependencies](https://docs.nestjs.com/fundamentals/circular-dependency), which occurs when two classes depend on each other.
- Implementation of code that generates performance problems and memory overflow;
- Absence of library or dependency imports;
- Absence of necessary configurations for the compilation of the application;

## 📋 Initial Checklist

Before proceeding to the mapped scenarios we have documented, follow the checklist to do a recap of the procedure required to fix problems that arise during the development cycle;

- **Search for the error on Google**, **in the Angular documentation**, and in the **development community**;
- If you haven't found a solution, write down all the points seen in each of these sources of information and try to draw your own diagnosis;
- Try to comment on code snippets that may be linked to the issue arising;

## 🎯 Mapped Scenarios

If the checklist above has been followed and the error proceeds, look in the list below for the scenario that most closely resembles yours:

### Compilation Errors

Documented possible solutions to this issue are:

- [AFE-NG-01: An unhandled exception occurred: ENOENT: no such file or directory, open '/dist/main.js'](./afe-ng-01.md)
- [AFE-NG-02: Cannot use import statement outside a module](./afe-ng-02.md)
- [AFE-NG-03: Initial exceeded maximum budget](./afe-ng-03.md)
- [AFE-NG-04: Asset path must start with the project source root](./afe-ng-04.md)
