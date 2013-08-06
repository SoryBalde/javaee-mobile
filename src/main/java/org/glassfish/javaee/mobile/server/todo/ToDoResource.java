package org.glassfish.javaee.mobile.server.todo;

import java.io.Serializable;
import java.util.List;
import javax.ejb.EJB;
import javax.enterprise.context.ApplicationScoped;
import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

@Path("todo/{username}")
@ApplicationScoped
public class ToDoResource implements Serializable {

    @EJB // @Inject should work.
    private ToDoService service;

    @POST
    @Consumes({"application/json"})
    public void create(
            @PathParam("username")
            @NotNull
            @Size(min = 6, max = 14) String username,
            @Valid ToDoItem item) {
        service.addToDoItem(username, item);
    }

    @PUT
    @Path("{id}")
    @Consumes({"application/json"})
    public void edit(
            @PathParam("username")
            @NotNull
            @Size(min = 6, max = 14) String username,
            @PathParam("id") Long id,
            @Valid ToDoItem item) {
        item.setId(id);
        service.updateToDoItem(username, item);
    }

    @DELETE
    @Path("{id}")
    public void remove(
            @PathParam("username")
            @NotNull
            @Size(min = 6, max = 14) String username,
            @PathParam("id") Long id) {
        service.removeToDoItem(username, id);
    }

    @GET
    @Produces({"application/json"})
    public List<ToDoItem> getAll(
            @PathParam("username")
            @NotNull
            @Size(min = 6, max = 14) String username) {
        return service.findToDoItemsByUsername(username);
    }
}