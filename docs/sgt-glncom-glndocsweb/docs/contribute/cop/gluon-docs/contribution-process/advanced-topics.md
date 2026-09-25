---
title: Advanced Topics
---

## 1. Gluon Docs Server: stating with mkdocs

Mkdocs requires direct server management. It lets you customize and configure Gluon Server with special options... as long as you accept investing some time learning mkdocks server...

#### Use a virtual environment

It is highly recommended to use a virtual environment, in order to isolate Gluon Docs configuration from any other use of python.

??? Info "Installing Virtual Environment"
    **Install:** Inside the repository root folder, using a terminal or command prompt:

    ``` bash
    pip install virtualenv
    ```

    **Create a virtual environment:** Inside the repository root folder, using a terminal or command prompt:

    ``` bash
    virtualenv .env
    ```

    > :memo: "**.env**" is the name of the virtual environment. The name is a reserved word, don't change it.

    **Completely delete a virtual environment:**

    To fully remove a virtual environment, just delete the .env directory that was created into the Creation step.

To run locally Gluon Docs, open a terminal or command and move to your Gluoon Docs project folder:

``` bash
# 1. Open a session with the virtual environment (only for virtual environment):
# If using Windows terminals
source .env\Scripts\activate
# If using Linux-based terminals
source .env/Scripts/activate
# Once open, the name of the environment will appear on top of the command pronmpt between parenthesys (.env)

# 2. Setup Gluon Docs environment
pip install -r requirements.txt

# 3. Start Gluon Server and access into a browser htt://localhost:8000
mkdocs serve  --dirty --no-strict
```

Finally, to end the session (once the job is done), call command deactivate:

``` bash
deactivate
```

Congrats! You're ready to start creating contents. If you need extra features, keep reading...

## Gluon Docs Server Optimizing

Gluon Docks is a documentation portal written in [Markdown](https://www.markdownguide.org/getting-started/).
 Whatever it's written with Markdown is shown as a web page into Gluon Docs, using [Gluon Docs server](./advanced-topics.md#1-gluon-docs-server-stating-with-mkdocs), which is based on [Mkdocs server](https://www.mkdocs.org/).
 Mkdocs server has multiple extensions and options to have a more efficient edition and validation process.

### Mkdocs configuration files

Main configuration files, at project base folder:

> :warning: Update of this file **into a Pull Request is forbidden**. Any specific request must go through the **Community Team**

- mkdocs.yml: Full server parametrization of mkdocs and extensions
- known_words.txt: List of words to exclude as spell issues, used by the extension spellcheck, english dictionary validator.
- .markdownlint.yml: the customization of some of the [markdown rules](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md) applied to control edition quality.
- requirements.txt: List of mkdocs plugins to enrich mkdocs experience.

### Mkdocs main plugins list

All these plugins setup can be accessed (and customized for edition locally) into mkdocs.yaml

> :warning: Update of this file **into a Pull Request is forbidden**. Any specific request must go through the [Community Team](./contributor-journey.md#gluon-docs-contribution-support).

- [mkdocs-material](https://squidfunk.github.io/mkdocs-material/): Website design for Mkdocs
- [mkdocs-markdownextradata-plugin](https://github.com/rosscdh/mkdocs-markdownextradata-plugin): Enable use of variables into mkdocs
- [mike](https://github.com/jimporter/mike): Support multiple versions of documentation
- [mkdocs-glightbox](https://github.com/blueswen/mkdocs-glightbox): supports image lightbox with GLightbox.
- [markdown-exec](https://pypi.org/project/markdown-exec/): Utilities to execute code blocks in Markdown files.
- [mkdocs-awesome-pages-plugin](https://github.com/lukasgeiter/mkdocs-awesome-pages-plugin): An MkDocs plugin that simplifies configuring page titles and navigation
- [mkdocs-spellcheck\[codespell\]](https://pypi.org/project/mkdocs-spellcheck/):  Checks the spelling of words using [codespell](https://github.com/codespell-project/codespell).
- [mkdocs-drawio-file](https://pypi.org/project/mkdocs-drawio-file/): To embed interactive drawio diagrams.

### How-to: Reduce server starting time

### 1. Just reload my section

Into mkdocs.yml:

``` yaml
# docs_dir variable to indicate on which directory to start rendering.
docs_dir: !ENV [GLUON_DOCS_DIR, 'docs/folder-name/']

# exclude_docs variable to exclude those folders that you don't want to render.
exclude_docs: |
  /folder-name-path/
```

> :warning: By excluding content, links to these files will not work either.

???+ danger "Important"
    Remember, it is **not allowed** to upload changes to the remote branch on the "*mkdocs.yml*" file.

### 2. Strict or no-strict server mode

When editing, no-strict mode keeps server running, but allows errors. Just for development purpose.

``` yaml
# Default behavior is strict, unless specified into mkdocs.yml
mkdocs server --no-strict
```

### 3. Reload as you edit

By default, mkdocs will fully reload every time a file is edited

``` yaml
# Extra argument --no-livereload avoids server reload with every page edition
mkdocs serve --no-livereload
```

Page reload: Just reload the edited page, more efficient, not always consistent

``` yaml
# Extra argument --dirty reloads the page as you edit
# Requires a no-strict mode
mkdocs serve --dirty --no-strict
```
