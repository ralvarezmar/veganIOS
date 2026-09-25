# BDD Testing

[Cucumber](https://cucumber.io/) is an important tool that supports Behavior
Driven Development (BDD), well known for being able to validate scenarios in the
universe of software testing.

Its library has been incorporated into the Arsenal Framework, as one of the
capabilities that most generated delivery value to the community.

!!! tip "Attention!"

    __But first, what is BDD?__

    BDD is an (agile) software development technique that makes defining features more efficient. Its entire perspective is based on the specification, as its use requires an approach that involves discovery, formulation/collaboration and automation. It is also known to drive team collaboration (quality, business, software, etc) as virtually any team member can build scenarios.

    _Recommended reading:_ https://cucumber.io/docs/bdd/

## What are scenarios?

Scenarios are contexts that, once given, specify what happens in a small story,
usually where a set of actions takes place (requirement, stimulus and result).
At the end of the day, it is the documentation of a behavior.

Let's look at a simple example BDD scenario below:

__Scenario:__ Transfer money to a savings account

    Given that I have a checking account with R$1,000.00
    And that I have a savings account with R$2,000.00
    When I transfer R$500.00 from my checking account to my savings account
    So I should have R$500.00 in my checking account
    And I should have $2,500 in my savings account

Note how easy it is to build a BDD scenario and how it can be created by any
member of the team, as long as we are able to specify an utterance based on the
Given-When-Then pattern.

| __ACTION__ | __DESCRIPTION__ |
|---|---|
| Given | Preconditions, prerequisites, steps to be reproduced |
| When | Final step to reproduce the behavior, action that triggers some event |
| Then | Expected behavior, predicted reaction |
