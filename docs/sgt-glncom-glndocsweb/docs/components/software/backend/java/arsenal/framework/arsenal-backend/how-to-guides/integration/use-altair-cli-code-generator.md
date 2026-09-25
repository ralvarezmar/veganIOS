# Using Altair Code Generator

Altair Code Generator is a standalone application capable of generating a JSON file containing CopyBook metadata from a mainframe transaction. The application searches for CopyBook transaction formats and creates a JSON file with the Altair response data.

## Prerequisites

To compile and run the application you will need:

- JDK 17+

## Getting started

Arsenal Gluon Altair Code Generator is a standalone application in order to be executed by your terminal.

### Download jar

To use the jar you need to install it, click here: [CLI Altair Code Generator](https://nexusmaster.alm.europe.cloudcenter.corp/repository/maven-releases/com/santander/ars/gln-cli-altair-connector/3.16.4/gln-cli-altair-connector-3.16.4.jar)

### Display help text

To list the options of the application just execute the `.jar` following by the `--help` option.

```bash
java -jar gln-cli-altair-connector-1.0.0.jar --help

Usage: Arsenal Altair Code Generator [options]
  Options:
    ...
    ...
```

### Usage

You can use the `-t` or `--transaction-codes` flag to specify a list of mainframe transactions with the desired CopyBook format, followed by `-o` or `--output-dir` to specify the JSON file output directory.

```bash
java -jar gln-cli-altair-connector-x.x.x.jar -t HA83,PE34,VA01 -o /your/output/dir/path
```

For each transaction a JSON file will be generated containing the metadata of the CopyBook formats.

It's also possible to pass customized MQ broker configuration as arguments to change where copybook will be retrieved.
Customizable parameters: **hostname**, **port**, **channel**, **requestQueue** and **responseQueue**.

Example:

```bash
java -jar gln-cli-altair-connector-x.x.x.jar -t HA83 -o /your/output/dir/path --hostname new.host --port 1000
```
