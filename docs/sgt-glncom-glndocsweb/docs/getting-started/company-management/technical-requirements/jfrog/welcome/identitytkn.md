# Identity Tokens in JFrog

## What is an Identity Token?

An Identity Token in JFrog is a type of access token that is scoped specifically to a user's permissions. It acts as a secure and temporary credential that allows users to authenticate and perform actions within the JFrog platform.
Identity Tokens are always reference tokens, meaning they are short strings that refer to the actual token stored securely in JFrog.

Identity Tokens are essential for accessing other types of tokens, such as Access Tokens and Reference Tokens, and provide a secure way to interact with JFrog services.

## How to Create an Identity Token

Follow these steps to create an Identity Token in JFrog:

### 1. Log in to the JFrog Platform

- Access your JFrog instance through the web interface.
- Navigate to the **Edit Profile** section.

### 2. Generate an Identity Token

- Click on **Generate an Identity Token**.
- Provide a description for the token and click **Next**.
- Click on **Create Token**.
- Copy the token immediately, as it will not be displayed again.

## Key Points to Remember

- **Temporary Nature**: Identity Tokens are temporary and must be securely stored after creation.
- **Reference Token**: The Identity Token is a reference token, meaning it is a short string that refers to the actual token stored in JFrog.
- **Access Control**: The token is scoped to the user's permissions, ensuring secure and limited access.
