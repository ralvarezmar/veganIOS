# Migration Guide

    All notable versions to project `gln-back-arsenal-integration-observability-starter` will be documented in this file.

## VERSION 4.3.0

<!tag:430>

 We've added intercept route names to help users see where the request is in the starter camel route through the logs and
 the option for users to set the isGluon property to be true or false instead of fixed true, and we've added new fields
 componentVersion and logVersion

<!end:430>

## VERSION 4.2.0

<!tag:420>

- Was updated the dependency arsenal-global-observability-starter to version 3.3.0

<!end:420>

## VERSION 4.1.1

<!tag:411>

- The MDC fields were cleaned after log to not mix data from one component with another that is been observed.

<!end:411>

## VERSION 4.1.0

<!tag:410>

- Was updated the dependency arsenal-global-observability-starter to version 3.2.0

<!end:410>

## VERSION 4.0.0

<!tag:400>

- We make the first release at Gluon based on gln-back-arsenal-integration-parent:4.0.0 with Apache Camel 4.0.0-M3

<!end:400>
