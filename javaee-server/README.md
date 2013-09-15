Java EE 7 server-side application targeting Android and iOS consisting of a chat WebSocket API
and a to do list REST API implemented using the Java API for WebSocket, JSON-P, JAX-RS 2, CDI, Bean Validation, EJB 3 and JPA.

The REST and WebSocket endpoints are secured. Before running the application, you must setup the right GlassFish security realm using the asadmin commands in 
the same directory as this file. You can also set the username/passwords via the database scripts in the source code. The passwords are stored as SHA-256
hashes. The current users are rrahman, rcurpak and bmuthuvarathan. The passwords are set to secret1.