{!
   include-markdown "**/ci-cd/technologies/snippets/common-project-secrets.md"
   start="<!--description-start-->"
   end="<!--description-end-->"
!}

## Api secrets

| Secret id                       | Type       | Description                             |
|---------------------------------|------------|-----------------------------------------|
| APICONNECT_ADMIN_USER_DEV       | Apiconnect | DEV apiconnect admin user               |
| APICONNECT_ADMIN_USER_DEV_PASS  | Apiconnect | DEV apiconnect admin password           |
| APICONNECT_USER_DEV             | Apiconnect | DEV apiconnect deploy user              |
| APICONNECT_USER_DEV_PASS        | Apiconnect | DEV apiconnect deploy password          |
| APICONNECT_ADMIN_USER_PRE       | Apiconnect | PRE apiconnect admin user               |
| APICONNECT_ADMIN_USER_PRE_PASS  | Apiconnect | PRE apiconnect admin password           |
| APICONNECT_USER_PRE             | Apiconnect | PRE apiconnect deploy user              |
| APICONNECT_USER_PRE_PASS        | Apiconnect | PRE apiconnect deploy password          |
| APICONNECT_ADMIN_USER_PRO       | Apiconnect | PRO apiconnect admin user               |
| APICONNECT_ADMIN_USER_PRO_PASS  | Apiconnect | PRO apiconnect admin password           |
| APICONNECT_USER_PRO             | Apiconnect | PRO apiconnect deploy user              |
| APICONNECT_USER_PRO_PASS        | Apiconnect | PRO apiconnect deploy password          |
| DATAPOWER_USER_DEV              | Apiconnect | DEV apiconnect datapower user           |
| DATAPOWER_USER_DEV_PASS         | Apiconnect | DEV apiconnect datapower password       |
| DATAPOWER_USER_PRE              | Apiconnect | PRE apiconnect datapower user           |
| DATAPOWER_USER_PRE_PASS         | Apiconnect | PRE apiconnect datapower password       |
| DATAPOWER_USER_PRO              | Apiconnect | PRO apiconnect datapower user           |
| DATAPOWER_USER_PRO_PASS         | Apiconnect | PRO apiconnect datapower password       |
| APIGEE_USER_DEV                 | Apigee     | App user for Apigee manager in dev      |
| APIGEE_PWD_DEV                  | Apigee     | App password for Apigee manager in dev  |
| APIGEE_USER_PRE                 | Apigee     | App user for Apigee manager in pre      |
| APIGEE_PWD_PRE                  | Apigee     | App password for Apigee manager in pre  |
| APIGEE_USER_PRO                 | Apigee     | App user for Apigee manager in pro      |
| APIGEE_PWD_PRO                  | Apigee     | App password for Apigee manager in pro  |
| SOS_CRED_ID                     | Apiconnect | SOS credential ID                       |

## Organization secrets

{!
   include-markdown "**/ci-cd/technologies/snippets/organization-secrets.md"
   start="<!--api-start-->"
   end="<!--api-end-->"
!}
