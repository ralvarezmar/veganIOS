# Authentication Modules

This section provides an overview of the authentication modules available, including their capabilities and usage instructions.

## Capabilities

- **Authentication**: Provide OAuth authorization flow (including implicit login).
- **Logout features**.
- **Token obtention, storage, rotation & injection**. Regarding the token storage, SCM offers two strategies:
  - [Closure](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures).
  - [Session Storage](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage).
- **PKCE (Proof Key for Code Exchange)**. PKCE is a simple extension to the OAuth 2.0 Authorization Code grant that prevents CSRF and authorization code injection attacks.
It's a lightweight mechanism that can be implemented in any application that requests an authorization code.

## Usage

### OAuth Authentication module

Review the [OAuth subpage](./oauth/index.md).

### CIP Authentication module

Review the [CIP subpage](./cip/index.md).
