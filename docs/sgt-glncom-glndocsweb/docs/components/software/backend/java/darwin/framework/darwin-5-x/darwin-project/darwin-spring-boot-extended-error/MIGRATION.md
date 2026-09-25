# Darwin-spring-boot-extended-error Migration guides

## Version 4.1.0-RELEASE

<!tag:410>

- For the **3.2.9-RELEASE**, we have recovered the original Extended Error format.
Keep in mind the ***Extended Error format*** was deleted in the **3.2.7-RELEASE**, and replaced by ***Gluon Error model***.
To maintain the previous behavior to this change,
you can delete the `darwin-spring-boot-starter-extended-error` dependency from the ***pom.xml***,
and you must configure the property `darwin.core.exceptions.error-format` to `GLUON` value.

<!end:410>
