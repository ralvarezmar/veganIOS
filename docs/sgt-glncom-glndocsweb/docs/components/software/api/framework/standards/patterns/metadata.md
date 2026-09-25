### **Metadata**

There are some use cases which may require to use data that its structure can be very variable or even not having data structure. The way to proceed is the following:

- If the data can be fully defined, it is mandatory to use a structure from the dictionary of terms.
- If the data has a json structure, but it can vary quickly through time, the solution is to define a structure as a **json object without any properties** in it. It MUST be included in the dictionary of terms detailing its purpose.

``` yaml
   ExampleField :
    type : "object"
    description : "Data structure containing metadata information"

```

- If none of the previous conditions are met, the solution proposed is to define a field coded in base 64 and to include it in the dictionary of terms.

``` yaml
   ExampleField :
    type : "string"
    format : byte
    description : "Data structure containing metadata information"

```
