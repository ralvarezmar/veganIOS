# Security Hardening for web applications

Hardening is the process of make something strong, by turning it harder from be exploited and consequently minimizing the vectors of attack of web application.

In this document, we will discuss the best practices to harden web applications, focusing on techniques, settings, and configurations that help enhance the security of your web applications.

## Goals of this document

The main goal of this analysis in web application is bringing to us consciousness the most effective techniques to harder our application, making it difficult to be broken or exploited.

## Security Principles  

These main principles will guide the design of a safe application:

- **Least Privilege**: states that users should only be given the minimum amount of access necessary to perform their job.
- **Defense-in-Depth**: recommends multiple layers of security controls to protect an organization’s assets. If one layer of security fails, the other layers will still be able to protect the asset.
- **Zero Trust**: assumes that all users, devices, and networks are untrusted and must be verified before access is granted.

## Know your application

A way to understand and identify possible attack vectors that it may present as defined by OWASP's [Abuse Case Overview](https://cheatsheetseries.owasp.org/cheatsheets/Abuse_Case_Cheat_Sheet.html) & [Attack Surface Analysis](https://cheatsheetseries.owasp.org/cheatsheets/Attack_Surface_Analysis_Cheat_Sheet.html).

In Gluon, this process is covered by the Threat Modelling phase of the Secure Development Lifecycle.

## Strategies and techniques

### [Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

Authentication is a process that confirms the identity of an individual, entity, or website. The front-end plays a crucial role in this process by managing the client-side aspects, by orchestrating the flows and handles the access tokens and refresh tokens.

### [Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)

Authorization is the act of verify if a requested action or service is approved for a specific entity in order to be executed. This concept is applied in front-end by checking if the user have enough privilege to access some functionality in the application.

We can reinforce this by implementing guards in all sensitive routes of the application.

### [Logging](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)

When logging in the client-side, make sure that **HTTPS connection is enabled** when messaging to the server, so no Man In The Middle (MITM) attack would be possible. Also ensure that data is encoded, and **sensitive information is encrypted.**

### [Third Party JavaScript Management](https://cheatsheetseries.owasp.org/cheatsheets/Third_Party_Javascript_Management_Cheat_Sheet.html)

Software libraries contain a collection of code that can be reused. However, they can also contain security vulnerabilities that attackers can exploit in order to gain access to the applications that use them or impact users of the application.

To mitigate this, always check for updates in the open source libraries used in your application. The [`npm audit`](https://docs.npmjs.com/cli/v9/commands/npm-audit) command can help to identify and update vulnerable packages.

### [File Upload](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)

File upload is a common feature in applications that allow upload of photos and files in the server of the website. This could be dangerous, once we should never trust in user input.

In order to mitigate file upload attacks, we have to reach a secure file upload implementation:

- Implement a maximum length;
- List only allowed extensions types instead of blocking specific extensions;
- Only allow authorized users to upload files;
- Ensure uploaded images are served with the correct content-type (`image/jpeg`), but always validate the file type, don't trust the Content-Type header as it can be spoofed
- Set a filename length limit. Restrict the allowed characters if possible and always sanitize the filename by generating a UUID/GUID or random string to properly rename the file.
  - For example, if the uploaded filename is `test.jpg`, then rename it to `JAI1287uaisdjhf.jpg`
- Use image rewriting libraries to verify the image is valid and to strip away extraneous content.
- Always validate a file extension. Be aware with double extensions (`.jpg.php`) or bypass like (`.php%00.jpg`)
- Store the files on a different server.
- Run the file through an antivirus or a sandbox environment to make sure that it doesn't contain virus.
Protect the file upload from [CSRF](#cross-site-request-forgery) attacks
- Set proper size limits for the upload service in order to protect the file storage capacity and protect the server from DoS attacks.

### [Input Validation](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
  
In summary, input validation should:

- Be applied to all input data, at minimum;
- Enforce correctness of the user input in the specific business context;
- Define the allowed set of characters to be accepted;
- Define a minimum and maximum length for the data;
- Be performed on the client and also performed on the server in order to re-force the validation;
- Array of allowed values for small sets of string parameters (days of week).
- Regular expressions for any other structured data covering the whole input string (^...$) and not using "any character" wildcard (such as `.` or `\S`)

## Defense and protection against attacks

### [Cross-Site Request Forgery](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)

 Cross-Site Request Forgery (CSRF) is a type of attack that occurs when a malicious website or attacker causes a user's web browser to perform an unwanted action on a trusted site when the user is authenticated.

 CSRF attacks are used by an attacker to make a target system perform a function via the victim's browser, without the victim's knowledge.

 There's a new variant of CSRF attacks, called **client-side CSRF**, performed when, for example, user inputs an URL that are controlled by the attacker, for generation of asynchronous HTTP requests, allowing the manipulation of the request endpoint parameters.

#### Mitigation

To protect your application against CSRF:

- Implement a built-in CSRF protections that generate tokens to guard CSRF vulnerable resources, like some frameworks such as [Angular](https://angular.dev/best-practices/security) does;
- Generate CSRF tokens from the server side;
- Enable CORS and set the `Access-Control-Allow-Origin` header equal to a secure and allowed origin;
- Store a list of predefined, safe request data in the JavaScript code.

### [Cross Site Scripting](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)

Cross Site Scripting (XSS) is a web vulnerability that allows an attacker to manipulate a vulnerable website so that malicious code be executed inside a victim's browser, with the aim of compromise their interaction with the application.

#### Mitigation

To avoid XSS, ensure that:

- Every untrusted data is only be treated as displayable text
- Always encode and delimit untrusted data as quoted strings, such as `let x = "<%= Encode.forJavaScript(untrustedData) %>";`
- Each variable in a web application is protected to avoid an attacker to insert and execute malicious content in a webpage. Ensuring that all variables go through validation and are then escaped or sanitized is known as perfect injection resistance.
- An HTML entity encoding is being used for all variables as you add it to a web template.
- The framework have enabled automatic encoding and escaping functions to prevent XSS.
- Avoid render HTML content with `.innerHTML`, because this will make the application render every HTML or Javascript code that could be in the payload. Use `.innerText` instead.
  
And to prevent most of the XSS attacks the server need to implement [Content Secure Policy (CSP)](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html) headers in order to:

- Preventing the page from executing inline script
- loading scripts from arbitrary servers
- defending against framing attacks using `frame-ancestors` CSP directive or `X-Frame-Options` to support old browsers
- restricting forms submissions to avoid injection of phishing.
- Generating unpredictable tokens for images guarantee the resources still be cached, while an attacker will not be able to find out about it.
- By configuring the `Cross-Origin-Resource-Policy` with the appropriate value, the browser will not load resources from our site or origin (even static images) in another application.

> A guide for XSS can be read in [XSS Filter Evasion Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/XSS_Filter_Evasion_Cheat_Sheet.html).

### [Unvalidated Redirects and Forwards](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html)

When a web application accepts untrusted input, this could allow an attacker to redirect the application to an untrusted URL defined by them to launch a phishing scam or steal user credentials.

#### Mitigation

Safe use of redirects and forwards can be done in a number of ways in order to avoid this vulnerability:

- Simply avoid using client-sides redirects and forwards
- Validate and sanitize user-input to determine whether the URL is safe. To see more about URL validation visit [Server Side Request Forgery Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html#application-layer)
- If user input can't be avoided, ensure that the supplied value is valid, safe in the context of application
- Create an allow-list approach or a regex of trusted hosts and URLs. Avoid block lists.
  
### [HTML5 Security](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html)

HTML5 brings to us a lot of useful and meaningful APIs to communicate in the client-side. Despite that, we need to carry about the best practices while using this features in order to maintain our application safe.

#### [Web Messaging](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html#web-workers)

Web Messaging (also known as Cross Domain Messaging) provides a means of messaging between documents from different origins. It is appropriate only where access to the data is not assuming authentication or authorization.

When implementing `postMessage API`, specify strict `targetOrigin` attribute instead of set `wildcard *`, otherwise any origin will be allowed to receive the message.

#### [Storage APIs](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html#web-workers)

It's recommended to avoid storing any sensitive information in local storage or session storage where authentication would be assumed.
One XSS attack can be used to steal all the data in these objects or load malicious data stored in the storage.

#### [Web Workers](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html#web-workers)

While Web Workers don't have access to DOM of the calling page, malicious Web Workers can use excessive CPU for computation, leading to **Denial of Service** condition or abuse **Cross Origin Resource Sharing** for further exploitation.

#### [Tabnabbing](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html#tabnabbing)

It's an attack where a page linked from the target page is able to rewrite that page and the objects instances, like `window.opener` in Javascript, to replace it with a phishing site.

```html
<html>
 <body>
  <li><a href="some-url.example.com" target="_blank">Vulnerable target using html link to open the new page</a></li>
  <button onclick="window.open('https://some-url.example.com')">Vulnerable target using javascript to open the new page</button>
 </body>
</html>
```

And the malicious code:

```html
<html>
 <body>
  <script>
   if (window.opener) {
      window.opener.location = "https://this-is-a-phishing.example.com";
   }
  </script>
 </body>
</html>
```

#### [Sandboxed frames](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html#sandboxed-frames)

The `sandbox` attribute of an iframe enables restrictions on content within an iframe. Use this attribute for untrusted content.

Once enabled, the plugins will be disabled as well as forms and scripts. Links will be prevented from targeting other browsing contexts and any auto invoked features will be blocked.

### [Credential and Personally Identifiable Information (PII)](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html#credential-and-personally-identifiable-information-pii-input-hints)

Text areas and input fields for Credential and Personally Identifiable Information PII (name, email, address, phone number) and login credentials (username, password) should be prevented from being stored in the browser.

Use these HTML5 attributes to prevent the browser from storing PII from your form:

- `spellcheck="false"`
- `autocomplete="off"`
- `autocorrect="off"`
- `autocapitalize="off"`

### [Cascading Style Sheets (CSS)](https://cheatsheetseries.owasp.org/cheatsheets/Securing_Cascading_Style_Sheets_Cheat_Sheet.html)

Maintaining readable and usable code is a priority for good programmers, however, this could inadvertently assist attackers in understanding the application's features. A CSS class named `addNewAdmin` could reveal information about the target website.

Use build-time and runtime tools such as [CSS in JS](https://cssinjs.org/?v=v10.10.0) and [CSS Modules](https://github.com/css-modules/css-modules) to obfuscate class names and reduce the likelihood of an attacker discerning the features of your application.

### [Clickjacking](https://cheatsheetseries.owasp.org/cheatsheets/Clickjacking_Defense_Cheat_Sheet.html)

Clickjacking, also known as a “UI redress attack”, is when an attacker loads an iframe and uses "invisible" layers to trick a user into clicking on a button or link and routing them to another page.

> Keystrokes can also be hijacked to a user can be led to believe they are typing in the password to their email or bank account, but are instead typing into an invisible frame controlled by the attacker.

Mitigation for Clickjacking includes:

- Preventing the browser from loading the page in frame and also prevent any domain from framing the content using the `X-Frame-Options` or `frame-ancestors` headers.
- Preventing session cookies from being included when the page is loaded in a frame using the [SameSite](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#samesitesamesite-value) cookie attribute.
- Implementing JavaScript code in the page to attempt to prevent it being loaded in a frame (known as a "frame-buster").
- Employing defensive code in the UI to ensure that the current frame is the most top level window.
- In scenarios where content must be frameable, then a `window.confirm()` can be used to help mitigate Clickjacking by informing the user of the action they are about to perform.
- Using the `sandbox` attribute in `iframes` can help restricting JavaScript in a subframe
- Include a ["frame-breaker"](https://cheatsheetseries.owasp.org/cheatsheets/Clickjacking_Defense_Cheat_Sheet.html#best-for-now-legacy-browser-frame-breaking-script) script in each page that should not be framed for browsers that do not support the `X-Frame-Options-Header`.

### [DOM Clobbering](https://cheatsheetseries.owasp.org/cheatsheets/DOM_Clobbering_Prevention_Cheat_Sheet.html)

DOM Clobbering is an HTML-only injection attack, where attackers confuse a web application by injecting HTML elements whose ID or name attribute matches the name of security-sensitive variables or browser APIs and overshadow their value.

Some ways to mitigate this attack:

- Dynamically check if named properties of the input mark has collisions with the existing DOM tree, and if that is the case, then remove named properties of the input markup.
- Use the [DOMPurify](https://github.com/cure53/DOMPurify) to remove all clobbering collisions with built-in APIs and properties by enabling the `SANITIZE_NAMED_PROPS` attribute, that would isolate the namespace of named properties by prefixing them.
- The [Sanitizer API](https://developer.mozilla.org/en-US/docs/Web/API/HTML_Sanitizer_API) can be configured to remove named properties despite not prevent DOM Clobbering.
- By implementing Content-Security Policy (CSP) we also can restrict the sources of JavaScript files to prevent malicious code from being injected into the page.
- Freeze sensitive DOM objects and their properties via `Object.freeze()` method.

Are some secure coding implementations that helps to avoid DOM Clobbering:

- Before inserting any markup into the webpage's DOM tree, sanitize id and name attributes
- When initializing variables, always use a declarator like `var`, `let` or `const`, which prevents clobbering of the variable.
- Avoid using objects like `document` and `window` for storing global variables, because they can be easily manipulated
- Always check the type of Document and Window properties before using them in sensitive operations, using the `instance` of operator.
- Use `strict mode` to prevent unintended global variable creation, and to raise an error when read-only properties are attempted to be over-written.
- Use feature detection to determine whether a feature is supported before using it. Unsupported feature APIs can act as an undefined variable/property in unsupported browsers, making them clobberable.
- Limit variables to local scope to avoid them to be overwritten by DOM Clobbering.
- Using unique variable names may help prevent naming collisions that could lead to accidental overwrites.
- Encapsulating variables and functions within objects or classes, like closure functions, can help prevent them from being overwritten.

## Defense and protection in frameworks and libraries

Frameworks are tools that help developers to build robust applications with powerful features and standards that increase quality, productivity and also security of the applications.

### Angular

To improve the defense of a Single Page Applications (SPA) developed with Angular we can use built-in protections against common web-application vulnerabilities and attacks provided by the framework:

#### `DomSanitizer.sanitize` to sanitize data

Sanitization is the inspection of an untrusted value, turning it into a value that's safe to be used in the application.
In Angular, we can sanitize the entries with the `sanitize()` method from `DomSanitizer` class, based on a [`SecurityContext`](https://docs.angular.lat/api/core/SecurityContext), that will tell us the criticality of the insertion in our application.

#### Secure your open redirects

Open redirect vulnerabilities occur when an application redirects a user to another URL based on user input. Suppose the user input is not properly sanitized or validated an attacker can use it to redirect somewhere outside the scope of the application.

```javascript
const returnUrl = params["returnUrl"];

if(returnUrl != null){
    document.location.href = returnUrl;
}else{
    document.location.href = "/";
}
```

When using internal links, it is best to make use of Angular's router module to handle navigation; this prevents any redirection to outside websites. For example:

```javascript

const returnUrl = params["returnUrl"];

if(returnUrl != null){
    this.router.navigate([returnUrl]);
}else{
    this.router.navigate(["/"]);
}
```

#### Prefer interpolation to render content in HTML template

Angular outputs encode all potentially dangerous text that could lead to XSS, given you're following the Angular secure coding practices, such as using the double curly braces `({{}})` to safely encode potentially dangerous characters and untrusted html.

#### Don't use unsafe Angular APIs

Some Angular APIs are marked as "**Security Risk**" in documentation and should be avoided. One of the most famous one are `ElementRef`, that's permits direct access to the DOM and can make your application vulnerable to [XSS attacks](#cross-site-scripting).

> Instead, use [Renderer2](https://angular.dev/api/core/Renderer2) that is more recommended.

Other Angular unsafe API is `DomSanitizer` with your *bypass* methods, that disables Angular's built-in sanitization. These methods below need to be used with carefully:

- `bypassSecurityTrustHtml`
- `bypassSecurityTrustStyle`
- `bypassSecurityTrustScript`
- `bypassSecurityTrustUrl`
- `bypassSecurityTrustResourceUrl`

### React

React is a library, not a framework. This limits the number of tools provided by them to help securize the developed applications.

#### Sanitize data with `DOMPurify`

React developers should sanitize data from untrusted sources before rendering it in HTML to prevent XSS vulnerabilities. The conventionally used `dangerouslySetInnerHTML` property serves as a warning of potential vulnerabilities when rendering user content.

To mitigate XSS attacks, consider sanitizing data with [`DOMPurify`](https://github.com/cure53/DOMPurify) before displaying any content. Alternatively, use JSX, which escapes strings by default, enhancing security.

```javascript
<p>Welcome <strong>{user.username}/></p>
```

Instead of:

```javascript
<p>Welcome <strong dangerouslySetInnerHTML={{__html: user.username}}/></p>
```

#### Use Lazy Loading to limit Access to code

Through [Authorization](#authorization) implementation, we can secure our code by restricting routes based on user access levels and using lazy loading to load code only for authorized users.
