# Unit test coverage in sonar

## Contextualization

During the implementation of an application in the HK environment, it is required by the conveyor belt that the source code of the project be analyzed statically.

In order to attest to the quality of the code. In this procedure, unit tests are also analyzed, while the other files must be added in ***exclusions*** so as not to be read by Sonar.

An example of the files that fall into the sonar exclusion rules would be:

- Configuration files (***.config.ts***)
- Module files, including [routes](https://angular.io/tutorial/toh-pt5#add-the-approutingmodule) (**.module.ts**)
- Interfaces and models (***.model.ts***, ***.interface.ts***)

To do this, you must change the value of the ***sonarExclusions*** property in the ***.ci/conf.yml*** file to:

```conf
sonarExclusions: '*/dist/,/node_modules/,/coverage/,/.spec.ts,*/.test.ts,*/.config.ts,*/.module.ts,*/.d.ts,*/.model.ts,*/.interface.ts,*/.enum.ts,*/.type.ts,*/.js,projects/-app/,/mocks/,/mocks_/*'
```
