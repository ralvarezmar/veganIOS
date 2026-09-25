# Using MapStruct

## Simple Mapper

As explained in the [functioning topic](../../concepts/dev-guides/mapstruct.md),
we have below the implementation of the three annotations mentioned in an interface,
in this example we also have a Mapper for lists, which implements the Mapping corresponding
to only one object inside a foreach.

``` { .java .copy}
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface AccountOwnerMapper {

    @Mapping(source = "name", target = "fullName")
    CustomerDTO accountOwnerToCustomerDTO(AccountOwner owner);
    @InheritInverseConfiguration
    AccountOwner customerDTOToAccountOwner(CustomerDTO customer);
    List<CustomerRequestDTO> customersToCustomerRequestDTOs(List<Customer> customers);
}
```

More than one model can also be used to be transformed into a DTO, provided that,
when there are parameters with the same name between the models, the one that will
be used must be specified in the source of the @Mapping annotation,
as shown in the example below:

``` { .java .copy}
@Mapping(source = "accountOwner.cpf", target = "accountOwnerIdentity")
CheckingAccountDTO accountOwnerAndCheckingAccountToCheckingAccountDTO
(AccountOwner accountOwner, CheckingAccount checkingAccount);
```

## Custom Mapper

A custom mapper is used when, to transform the model into a DTO, there is a
specific logic. To specify this logic, we must include the default access identifier
and implement the necessary code, as shown in the example below:

``` { .java .copy}
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface CheckingAccountMapper {

    default CheckingAccountResponseDTO toCheckingAccountResponseDTO
        (CheckingAccount checkingAccount) {
        String status = "";
        if (checkingAccount.isActive()) {
            status = AccountStatus.ACTIVE.toString();
        } else {
            status = AccountStatus.INACTIVE.toString();
        }
        return new CheckingAccountResponseDTO(checkingAccount.getNumbering().getBranch(),
            checkingAccount.getNumbering().getAccount(), MoneyUtils.toMoneyFormat(checkingAccount.getBalance()),
            status);
    }
    default CheckingAccount fromCheckingAccountResponseDTO
        (CheckingAccountResponseDTO checkingAccountResponseDTO) {
        CheckingAccount checkingAccount = new CheckingAccount();
        AccountNumbering numbering = new AccountNumbering();
        numbering.setBranch(checkingAccountResponseDTO.getBranchNumber());
        numbering.setAccount(checkingAccountResponseDTO.getAccountNumber());
        checkingAccount.setNumbering(numbering);
        checkingAccount.setBalance(MoneyUtils.toCents(checkingAccountResponseDTO.getBalance()));
        if (checkingAccountResponseDTO.getStatus()
            .equals(AccountStatus.ACTIVE.toString())) {
            checkingAccount.setActive(true);
        } else {
            checkingAccount.setActive(false);
        }
        return checkingAccount;
    }
}
```

## Getting and Running a Mapper

To obtain a Mapper, it is necessary to inject its dependency into the class that
will use it, as shown in the example below:

``` { .java .copy}
@Autowired
private CustomerMapper customerMapper;
```

!!! warning
    For the mapper injection to work correctly, it is important to insert the
    parameter (componentModel = "spring") in the @Mapper annotation.

To run a Mapper, we just need to call the mapper method already injected by Spring.

``` { .java .copy}
AccountOwner accountOwner = accountOwnerMapper.customerDTOToAccountOwner(customer);
```

## Mappers present in tests

In case Mapper is present in ***unit tests***, it is necessary to get it and
declare it in another way, ***in all the places used***.

To declare it, we need to include the injectionStrategy in the annotation parameters,
which represents the way in which the Mapper will be instantiated. In this case,
we need to declare the injection strategy through ***constructors***.

``` { .java .copy}
/** Mapper class for Customer model and DTOs. */
@Mapper(componentModel = "spring", injectionStrategy = InjectionStrategy.CONSTRUCTOR)
public interface CustomerMapper {
    //...
}
```

To obtain it, in this case, it will not be enough to just include @Autowired
in the property. We need to include the attribute in the constructor of
***all classes that use*** it (services), as shown in the example below:

``` { .java .copy}
private final CustomerMapper mapper;
@Autowired
public CustomerServiceV2Impl(CustomerMapper mapper) {
    this.mapper = mapper;
}
```

In the test classes, it is necessary to inject the Mapper in another way,
even if it is already in the class that will be used by the test, we need to declare
it with the @Spy annotation, which represents that it will be "spied" through the
class that uses it. This must be instantiated by Mappers.getMapper, as shown in
the example below:

``` { .java .copy}
@Spy
private CustomerMapper mapper = Mappers.getMapper(CustomerMapper.class);

@InjectMocks
CustomerServiceV2Impl service;
```

## Exceptions

When exceptions are thrown by the classes being mapped, in the Mapper interface,
it is necessary to declare them with ***throws***, so that the implementation class
has the necessary treatment for the error, throwing a RuntimeException.
To learn more, see the error handling documentation.

``` { .java .copy}
CustomerDTO accountOwnerToCustomerDTO(AccountOwner owner) throws BusinessException;
```

## Null Treatment

In class mapping, when the mapstruct finds a null value in the class we are
trying to transform, it returns a null value for the class we want to get.
However, it has features that can replace null with a default value,
or even ignore this null value in the mapping.

### NullValueMappingStrategy

This property can be inserted in the main annotation of the class, with the
definition of NullValueMappingStrategy.RETURN_DEFAULT, which returns
empty or indifferent values, instead of null, for example:
for boolean variables, the return will be false, for integers 0, for collections,
will be empty.

``` { .java .copy}
// ...
import org.mapstruct.Mapper;
import org.mapstruct.NullValueMappingStrategy;
//...
@Mapper(componentModel = "spring", nullValueMappingStrategy = NullValueMappingStrategy.RETURN_DEFAULT)
public interface CheckingAccountMapper {
    //...
}
```

### NullValuePropertyMappingStrategy

Like the NullValueMappingStrategy, this property, when defined with
NullValuePropertyMappingStrategy.SET_TO_DEFAULT, returns empty or indifferent
values, instances with empty properties, as well as lists, for this reason,
the classes that will use it need empty constructors. When set to
NullValuePropertyMappingStrategy.IGNORE, returns the same values s the original
entity. Can be used in @Mapper and @Mapping annotations.

*Default Value*
The default value parameter serves to specify a value that is desired when a
given field is empty or null.

``` { .java .copy}
// ...
import org.mapstruct.Mapper;
import org.mapstruct.NullValuePropertyMappingStrategy;
//...
@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.SET_TO_DEFAULT)
public interface CheckingAccountMapper {
    @Mapping(source = "name", target = "fullName", defaultValue = "Unspecified Field")
    CustomerDTO accountOwnerToCustomerDTO(AccountOwner owner);
}
```

### NullValueCheckingStrategy

This property can be inserted in the main annotation of the class and also in the
annotation of the method, which can have two variations, ALWAYS and
ON_IMPLICIT_CONVERSION, however, both check if the fields exist before
inserting the attribute in the mapped class.

#### ON_IMPLICIT_CONVERSION

This configuration defines that the verification of fields that can be null
must be done when there is data conversion, for example,
from an Integer field to int.

``` { .java .copy}
// ...
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
//...
@Mapper(componentModel = "spring")
public interface CheckingAccountMapper {
    @Mapping(source = "ownerId", target = "id", nullValueCheckStrategy = NullValueCheckStrategy.ON_IMPLICIT_CONVERSION)
    CustomerDTO accountOwnerToCustomerDTO(AccountOwner owner);
}
```

#### ALWAYS

This configuration defines that the verification of fields that can be null must
always be carried out.

``` { .java .copy}
// ...
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
//...
@Mapper(componentModel = "spring")
public interface CheckingAccountMapper {
    @Mapping(source = "name", target = "fullName", nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
    CustomerDTO accountOwnerToCustomerDTO(AccountOwner owner);
}
```
