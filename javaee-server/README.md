Java EE 7 server-side application targeting Android and iOS consisting of a chat WebSocket API
and a to do list REST API implemented using the Java API for WebSocket, JSON-P, JAX-RS 2, CDI, Bean Validation, EJB 3 and JPA.

The REST and WebSocket endpoints are secured. Before running the application, you must setup the right GlassFish security realm using the asadmin commands in 
the same directory as this file. You can also set the username/passwords via the database scripts in the source code. The passwords are stored as SHA-256
hashes. The current users are rrahman, rcurpak and bmuthuvarathan. The passwords are set to secret1.

The project is in standard Maven format. You should be able to open it using any IDE that supports Maven and run it using any Java EE 7 container. However,
we used NetBeans and GlassFish 4. Note that the project uses the default Derby database that comes with GlassFish. Here are the instructions to get up and running
using NetBeans and GlassFish:

* Install JDK 7
* Install GlassFish 4+
* Install the NetBeans 7.3+ Java EE version
* Setup GlassFish in NetBeans (make sure Derby is started with GlassFish)
* Open and build the project
* Run the project on GlassFish 4
* Execute the asadmin commands in the 'create-mobile-realm.bat' file. The second command is more important and the first one might fail, so don't execute the batch file directly
* Open up a browser and go to http://localhost:8080/javaee-mobile-server

The application welcome page documents the APIs that the server makes available. You can use tools like soapUI, Postman and Simple Web Socket Client to test out
the APIs.