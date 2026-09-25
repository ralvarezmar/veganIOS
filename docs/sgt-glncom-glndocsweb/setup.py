import setuptools
from version import __version__

setuptools.setup(
    name = "glndocsweb",
    version = __version__,
    author = "Juanjo del Campo",
    author_email = "juanjo.delcampo@gruposantander.com",
    description = "Gluon Docs Web microservice",
    long_description = "Gluon Docs Web microservice",
    long_description_content_type = "text/markdown",
    url = "https://gluon.gs.corp/docs/",
    packages = setuptools.find_packages(),
    classifiers = [
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    install_requires = [
    ],
    python_requires = '>=3.11',
)
