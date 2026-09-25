# Run Arsenal Message Driven project with plugin (Eclipse)

We recommend installing the Spring Boot plugin available on the Eclipse
Marketplace itself. This will ease the process of building and running an
Arsenal project.

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

* Arsenal Message Driven offers ready-made configurations through configuration
* files (application.yml and application-local.yml) so that we can make
* connections with Apache Kafka or RabbitMQ, without the need for code changes.
* With the project already created, go to "Run As" > "Spring Boot App". This
* will make your application launch from application.yml which is configured to
* connect as Kafka. To learn how to configure Apache Kafka click here.

    If at the start of the application the LOG shows that port 8080 is in use,
    it is likely that Zookeeper is using it. You can change the Zookeeper
    settings or adjust the application's server:port to run quik start. It is
    important to point out that we are approaching for this material the
    execution of Kafka and RabbitMQ in a local environment.

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-8.png "Quickstart
    Arsenal").

* You will be able to start the application from your local profile (specified
* in the application-local.yml file). This way the application will be started
* connected to RabbitMQ, for that "Run Configurations".

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-9.png "Quickstart
    Arsenal").

* Fill in the fields with the respective information of the created project. In
* profile insert the profile you want, example: local:

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-10.png "Quickstart
    Arsenal").

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-11.png "Quickstart
    Arsenal").

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-12.png "Quickstart
    Arsenal").

* Select "Apply" > "Run" to run the application.

* Your console should generate output similar to this:

    ![alt text for screen
    readers](../../assets/images/quickstart-arsenal-14.png "Quickstart
    Arsenal").
