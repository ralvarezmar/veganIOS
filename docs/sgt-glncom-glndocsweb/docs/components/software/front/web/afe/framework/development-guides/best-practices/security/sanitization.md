# Best practices in sanitizing user inputs

**🎓 What will you learn?**

- What is sanitization?
- How to sanitize user-provided information
- How to sanitize user-executed commands
- How to sanitize user-uploaded files
- How to sanitize files before storing them on the server

## Introduction

Data sanitization consists of performing the proper **treatment of user input** before performing any operation that may compromise the system or application.

According to [OWASP](https://owasp.org/Top10/A03_2021-Injection/), 94% of applications have already been tested for some form of arbitrary injection of malicious code, whether SQL Injection, XSS (Cross Site Scripting), or terminal command injection.

One of the factors that contribute to this vulnerability being so common is the lack of validation of user input, one of the main attack vectors of a system. > Never trust a user's input.

## Sanitization techniques

When dealing with user input, consider the following reflection:

> Is there a possibility for the user to enter a malicious entry?**

And based on that, implement user input validation on both the front-end and the back-end.

### Information provided by the user

- Use regular expressions to allow only what is expected;
- Set a very strong validation standard for well-structured data, such as dates, social security numbers, zip codes, email addresses, etc.
- Check the minimum and maximum length and range for strings and numbers;
- Explicitly convert the data before working with it;
- Make sure that no invalid characters are present.

### User-executed commands

- Validate that the characters you type are all alphanumeric;
- Create a list of allowed commands;
- Remove any reserved characters ***|***, ***;***, or ***&*** when executing the command;
- Remove any external commands. Use the existing ones inside the shell (built-in);
- When using [child_process](https://nodejs.org/api/child_process.html), prefer the [child_process.spawn](https://nodejs.org/api/child_process.html#child_processspawncommand-args-options) command.
- As it expects to receive the name of the command as the first argument and its arguments as the second. This way, any extra commands passed are treated as arguments. This prevents arbitrarily added commands from being executed.

### User-uploaded files

- Validate that the name of the uploaded file has a valid extension, through a list of allowed extensions;
- Set a maximum size for the file to be uploaded.

### Files stored on the server

- Always rename the file before storing it;
- The location where the file will be stored should be decided by the server, never by the client.

## References

- <https://portswigger.net/web-security/os-command-injection>
- <https://santander.immersivelabs.online/v2/labs/node-js-blind-command-injection/>
- <https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch01s09.html#:~:text=A%20built%2Din%20command%20is,for%20a%20couple%20of%20reasons>
- <https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html>
