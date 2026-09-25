# Referencing a release with a ticket in Jira

By setting the ***version.issueUrlFormat*** property in ***afe.json***, whether the default value is or not, whenever a version is generated through a Jira ticket or other issue tracking tool.

It is possible to add the ***Refs #id*** syntax to the footer of the commit message, as in the example below:

``` BASH
git commit -m "fix: Behavior fix" -m "Refs #JIRA-999"
```

Resulting in:

``` MD
## 5.7.1 (2020-02-06)

### Fixes

* Behavior fix, close-ups [#JIRA-999](https://jira.santanderbr.corp/browse/JIRA-999)
```
