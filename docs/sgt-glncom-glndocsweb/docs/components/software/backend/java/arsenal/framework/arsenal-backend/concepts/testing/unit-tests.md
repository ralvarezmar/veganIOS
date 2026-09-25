# Unit Test

Unit tests are tests that focus on small units of code, such as methods and
classes. In unit tests, all dependencies of a class must be removed, replacing
them with a specific implementation for testing, or even with an object that
simulates the original behavior (a mock).

Unit tests should not test the interaction between components! For this type of
testing see the Integration Testing capability.

## Why do unit tests?

Implementing unit tests allows solving two problems that interfere with the
quality of an application:

* high rate of defects (frequent errors in operation);
* system deterioration (problems that can render the application unusable in the
  long term).

In addition to these listed reasons, unit tests help the developer to verify
that the implemented logic is correct, to detect if a change in the code has
introduced a flaw and also facilitate the development of new features as they
can be automated, reducing the need for manual testing.

## Unit Test vs. Integration Test

Another important thing to consider is the difference between unit testing and
integration testing.

The purpose of a unit test in software engineering is to verify the behavior of
a relatively small piece of software, independently from other parts. Unit tests
are narrow in scope, and allow us to cover all cases, ensuring that every single
part works correctly.

On the other hand, integration tests demonstrate that different parts of a
system work together in the real-life environment. They validate complex
scenarios (we can think of integration tests as a user performing some
high-level operation within our system), and usually require external resources,
like databases or web servers, to be present.

Let's go back to our mad scientist metaphor, and suppose that he has
successfully combined all the parts of the chimera. He wants to perform an
integration test of the resulting creature, making sure that it can, let's say,
walk on different types of terrain. First of all, the scientist must emulate an
environment for the creature to walk on. Then, he throws the creature into that
environment and pokes it with a stick, observing if it walks and moves as
designed. After finishing a test, the mad scientist cleans up all the dirt, sand
and rocks that are now scattered in his lovely laboratory.

Notice the significant difference between unit and integration tests: A unit
test verifies the behavior of small part of the application, isolated from the
environment and other parts, and is quite easy to implement, while an
integration test covers interactions between different components, in the
close-to-real-life environment, and requires more effort, including additional
setup and teardown phases.

A reasonable combination of unit and integration tests ensures that every single
unit works correctly, independently from others, and that all these units play
nicely when integrated, giving us a high level of confidence that the whole
system works as expected.

However, we must remember to always identify what kind of test we are
implementing: a unit or an integration test. The difference can sometimes be
deceiving. If we think we are writing a unit test to verify some subtle edge
case in a business logic class, and realize that it requires external resources
like web services or databases to be present, something is not right —
essentially, we are using a sledgehammer to crack a nut. And that means bad
design.

## How to Write Unit Test Cases

Before diving into the main part of this tutorial and writing unit testing and
coding, let's quickly discuss the properties of a good unit test. Unit testing
principles demand that a good test is:

__Easy to write.__ Developers typically write lots of unit tests to cover
different cases and aspects of the application's behavior, so it should be easy
to code all of those test routines without enormous effort.

__Readable.__ The intent of a unit test should be clear. A good unit test tells
a story about some behavioral aspect of our application, so it should be easy to
understand which scenario is being tested and — if the test fails — easy to
detect how to address the problem. With a good unit test, we can fix a bug
without actually debugging the code!

__Reliable.__ Unit tests should fail only if there's a bug in the system under
test. That seems pretty obvious, but programmers often run into an issue when
their tests fail even when no bugs were introduced. For example, tests may pass
when running one-by-one, but fail when running the whole test suite, or pass on
our development machine and fail on the continuous integration server. These
situations are indicative of a design flaw. Good unit tests should be
reproducible and independent from external factors such as the environment or
running order.

__Fast.__ Developers write unit tests so they can repeatedly run them and check
that no bugs have been introduced. If unit tests are slow, developers are more
likely to skip running them on their own machines. One slow test won't make a
significant difference; add one thousand more and we're surely stuck waiting for
a while. Slow unit tests may also indicate that either the system under test, or
the test itself, interacts with external systems, making it
environment-dependent.

__Truly unit, not integration.__ As we already discussed, unit and integration
tests have different purposes. Both the unit test and the system under test
should not access the network resources, databases, file system, etc., to
eliminate the influence of external factors.
