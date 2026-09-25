# Project Lombok

![lombok1](../../assets/images/lombok1.png)

[Lombok](https://projectlombok.org/) is a project focused on reducing common
Java language verbosity, so that the developer no longer needs to spend time
writing boilerplate code such as getter, setter, builder, constructors, among
many others that we are already used to.

The library automatically "connects" with your IDE
([Eclipse](https://www.eclipse.org/),
[IntelliJ](https://www.jetbrains.com/pt-br/idea/),
[VSCode](https://code.visualstudio.com/), etc) and also with your build tool
([Maven](https://maven.apache.org/), [Gradle](https://gradle.org/), etc),
providing the developer with more agility during the elaboration of their codes,
make use of specific annotations that abstract the use of repetitive code.

The "Project Lombok" library has been built into the Arsenal Framework since
version 1.4.0, as one of the capabilities most awaited by the community.

## What annotations can I use?

There is a vast list of resources that can be used with Lombok in your project.
See official documentation for more details. Below, some examples

[@NonNull](https://projectlombok.org/features/NonNull)

or: How I learned to stop worrying and love the NullPointerException.

[@Cleanup](https://projectlombok.org/features/Cleanup)

Automatic resource management: Call your close() methods safely with no hassle.

[@Getter/@Setter](https://projectlombok.org/features/GetterSetter)

Never write public int getFoo() {return foo;} again.

[@ToString](https://projectlombok.org/features/ToString)

No need to start a debugger to see your fields: Just let lombok generate a
toString for you!

[@EqualsAndHashCode](https://projectlombok.org/features/EqualsAndHashCode)

Equality made easy: Generates hashCode and equals implementations from the
fields of your object..

[@NoArgsConstructor, @RequiredArgsConstructor and
@AllArgsConstructor](https://projectlombok.org/features/constructor)

Constructors made to order: Generates constructors that take no arguments, one
argument per final / non-nullfield, or one argument for every field.

[@Data](https://projectlombok.org/features/Data)

All together now: A shortcut for @ToString, @EqualsAndHashCode, @Getter on all
fields, and @Setter on all non-final fields, and @RequiredArgsConstructor!

[@Value](https://projectlombok.org/features/Value)

Immutable classes made very easy.

[@Builder](https://projectlombok.org/features/Builder)

... and Bob's your uncle: No-hassle fancy-pants APIs for object creation!

[@SneakyThrows](https://projectlombok.org/features/SneakyThrows)

To boldly throw checked exceptions where no one has thrown them before!

[@Synchronized](https://projectlombok.org/features/Synchronized)

synchronized done right: Don't expose your locks.

[@With](https://projectlombok.org/features/With)

Immutable 'setters' - methods that create a clone but with one changed field.

[@Getter(lazy=true)](https://projectlombok.org/features/GetterLazy)

Laziness is a virtue!

[@Log](https://projectlombok.org/features/log)

Captain's Log, stardate 24435.7: "What was that line again?"

> To see a usage of Lombok [click
> here](../../how-to-guides/dev-guides/use-lombok.md).
