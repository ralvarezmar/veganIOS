# Gluon API Policies Framework - Changelog

## Summary of Key Changes

### Version Evolution

- **V1.6.2**: No policy version changes

- **V1.5.0**: No policy version changes

- **V1.3.2**: JWSId policies updates in Apigee and IBM

- **V1.3.0**: No policy version changes

- **V1.2.7**: Base documented version

---

## V1.6.2

No policy version changes

---

## V1.5.0

No policy version changes

---

## V1.3.2

### Changes

#### Apigee Policies

- **gln-jwsid-generate**: `2.2.3` → `2.4.0`

- **gln-jwsid-validate**: `1.4.1` → `1.5.0`

#### IBM API Connect v10 Policies

- **gln-jwsid-generate**: `2.2.2` → `2.3.0`

---

## V1.3.0

No policy version changes

---

## V1.2.7

### Initial documented version

This is the first fully documented version in the file that includes:

#### Apigee Policies (18 policies)

- gln-cors (2.0.2)
- gln-verify-client-id (1.0.3)
- gln-authorization-validation (1.0.1)
- gln-jwsid-validate (1.4.1)
- gln-jwsid-generate (2.2.3)
- gln-cosac (2.0.1)
- gln-error-control (1.1.0)
- gln-set-app-name-header (1.0.0)
- gln-whitelist (1.0.1)
- gln-blacklist (1.0.1)
- gln-sca-operative-signature (1.0.2)
- gln-rate-limit (1.0.0)
- gln-burst-limit (1.0.0)
- gln-json-message-validation (2.0.0)
- gln-obfuscation (2.0.0)
- gln-set-target (1.0.0)
- gln-schema-validation-request (1.0.0)
- gln-schema-validation-response (1.0.0)

#### IBM API Connect v10 Policies (11 policies)

- gln-obfuscation (2.0.0)
- gln-sca-operational-signature (1.1.1)
- parse (2.0.0)
- invoke (2.3.0)
- gln-whitelist (1.0.1)
- gln-blacklist (1.0.1)
- CORS (1.0.0)
- gln-jwsid-generate (2.2.2)
- gln-jwsid-validate (2.0.0)
- gln-cosac (2.0.1)
- validate (2.0.0)

#### AWS Policies

- Integration types: vpc-link, lambda (aws, aws_proxy)
- Authorizer types: lambda

#### Infrastructure Security Global Policies (4 policies for both Apigee and IBM)

- SQL Injection & NoSQL Injection (1.0.0)
- OS Command Injection (1.0.0)
- LDAP Injection (1.0.0)
- OS Command Injection
