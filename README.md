A sample application that demostrates using native mobile Android and iOS clients using a Java EE 7 backend. The server-side consists of a chat WebSocket API
and a to do list REST API implemented using the Java API for WebSocket, JSON-P, JAX-RS 2, CDI, Bean Validation, EJB 3 and JPA.

The server-side code is in the 'javaee-server' directory, while the Android and iOS clients are in the 'android-client' and 'ios-client' directories. For 
context around this project, check out the 'javaee_mobile.ppt' file. You will need to get the server up and running first and then the clients.

To Do
=====
* Make self-signed SSL certs work on iOS.
* Make an HTML 5 client?