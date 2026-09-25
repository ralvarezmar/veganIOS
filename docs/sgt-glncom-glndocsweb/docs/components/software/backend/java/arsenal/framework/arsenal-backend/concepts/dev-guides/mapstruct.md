# MapStruct

Object mapping consists of transforming classes that represent models into data
transfer objects (DTOs) and vice versa. To facilitate this mapping, which could
be done manually, there are some libraries, such as MapStruct, which we will
discuss in this article.

MapStruct is a library that aims to facilitate the transformation of objects
from one class to another corresponding one through annotations and
implementation classes.

## Functioning

So that we can take advantage of the library, it is necessary to create an
interface that will contain the annotation @Mapper(componentModel = "spring"),
after its inclusion, the signatures will correspond to the toDto and fromDto
methods, previously implemented in the model classes, if applicable. the fields
of both classes have matching names.

If the fields do not match, it is necessary to include the annotation
@Mapping(source = "name", target = "fullName") over the signature of the
interface methods, where source corresponds to the field of the class that we
want to transform and target corresponds to the field of the class we want to
get.

We can use the @InheritInverseConfiguration annotation for the method that
performs the inverse conversion of the method that is annotated with
@Mapping(...), to avoid repeating the same source and target settings.

After making use of the necessary annotations, when compiling the project, a
mapper implementation class is generated, which is responsible for transforming
the current object into the desired one, in a transparent way for the
developers.

!!! warning

    Classes that will have mappers defined by MapStruct must have
    getters and setters implemented!

If more than one @Mapping is used, the @Mappings annotation can be used to
organize them, separated by a comma, as shown in the example below:

``` { .java .copy}
@Mappings({@Mapping(source="customerId", target = "id"), @Mapping(source = "customerName", target = "name")})
CustomerResponseDTO customerToCustomerResponseDTO(Customer customer);
```

> To see a usage of MapStruct [click
> here](../../how-to-guides/dev-guides/use-mapstruct.md).
