# Code Style

Code conventions and programming guidelines are essential for several reasons:

* Maintenance represents 80% of the lifetime cost of a software project;
* Hardly a software project is maintained by the original author for its entire
  life;
* Create consistency and improve software readability, allowing developers to
  understand new code faster and more fully;
* If you distribute your source code as a product, your code must be clean,
  well-structured and packaged just like a final product. The care and attention
  given to the final product must extend to the code, promoting quality to what
  gives life to the product.

## Language

The language to be used in development and programming is English. All code,
including comments and settings, must be written in English. In this way, we can
share knowledge with Banco Santander developers from other countries (Banco
Santander is currently present in more than 30 countries).

We are in Brazil and our language is Portuguese, so we know that there are
exceptions specific to the Brazilian context. In these cases, the writing of
terms in Portuguese is allowed, such as: names of regulatory bodies (BACEN), tax
names (IOF), acronyms and terms of the banking industry (CNAB), or even words
like "Boleto". Very well known acronyms and abbreviations are also accepted in
Portuguese, such as "CPF" and "CNPJ".

## Code Styles

Your code should be written following the Java language style standards already
adopted by much of the technology industry.

These standards were defined by Sun, incremented by Oracle and later also by
Google.

You can see the standards in detail in the first two links in the
[References](./code-style.md#references) section of this article.

## Continuous Code Style Inspection

You can integrate automation tools with your development environment to run
routines that check and evaluate code against established standards. One option
is the Checkstyle tool, responsible for performing this type of analysis.
Checkstyle is already running today in the wake of DevOps and the results are
already published in the [SonarQube](http://sonar.produbanbr.corp/) tool, but
you can also run it locally and make corrections before you even commit your
code and run DevOps.

## References

1. [Code Conventions for the Java Programming Language
   (Oracle)](https://www.oracle.com/java/technologies/javase/codeconventions-contents.html)
2. [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
3. [Checkstyle](https://checkstyle.org/)
