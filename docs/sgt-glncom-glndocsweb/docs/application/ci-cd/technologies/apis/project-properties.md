{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-properties.md"
   start="<!--description-start-->"
   end="<!--description-end-->"
!}

## Api properties for deployment

| Property                  | Required |   Type            |   Description                                   |
|---------------------------|----------|-------------------|-------------------------------------------------|
| ARCHETYPE_DIRECTORY       | true     | apigee            | Archetype used for build apigee artifact        |
| API_PLATFORM              | true     | apiconnect/apigee | Api manager where deploy is made                |
| APICONNECT_CATALOG_SPACE  | true     | apiconnect        | Space where deploy is mande inside ApiConnect   |

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-properties.md"
!}
