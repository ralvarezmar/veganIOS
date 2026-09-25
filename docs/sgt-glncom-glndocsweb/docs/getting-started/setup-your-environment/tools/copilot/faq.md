---
hide:
  - toc
---
# Frequently Asked Questions

## I am experiencing connectivity issues. What can I do?

If you are using Copilot from your local IDE, you may experience connectivity issues due to proxy or certificates within Santander network. The following issues have been reported:

- **\[Error] [default] Request Error: unable to get local issuer certificate** in Visual Studio Code (Windows laptops).

  This error is caused by the IDE not being able to validate the certificate of the Copilot server. To fix this in WINDOWS laptops, you can install "win-ca" VSCode extension.
  This extension will allow you to add the certificate of the Copilot server to the list of trusted certificates in your laptop.
  