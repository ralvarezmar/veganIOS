# Run Arsenal MongoDB project with plugin (Eclipse)

* Select "Help" > "Eclipse Marketplace...".

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-5.png "Quickstart
    Arsenal").

* In the search field, search for "spring boot", select the plugin and start the
  installation.

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-6.png "Quickstart
    Arsenal").

* Accept the license terms of use.

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-7.png "Quickstart
    Arsenal").

!!! tip "Attention!"

    If you already have a local MongoDB instance, feel free
    to replace it.

Thus, it will only be available in the background, and its operation through
plugins running in IDEs can cause port conflicts or the simple inability to keep
MongoDB available. This scenario can be found with the Spring Tools 4 plugin.

We therefore recommend two alternatives to run the application and,
consequently, the MongoDB instance:

* Use a Maven Run Configuration, passing the spring execution instructions;

* Use the terminal to run the application via Maven with the spring execution
  instructions;
