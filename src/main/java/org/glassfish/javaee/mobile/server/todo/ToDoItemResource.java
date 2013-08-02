package org.glassfish.javaee.mobile.server.todo;

import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

@Stateless
@Path("todo/{username}")
public class ToDoItemResource {

    @PersistenceContext
    protected EntityManager entityManager;

    @POST
    @Consumes({"application/json"})
    public void create(@PathParam("username") String username,
            ToDoItem item) {
        item.setUsername(username);
        entityManager.persist(item);
    }

    @PUT
    @Path("{id}")
    @Consumes({"application/json"})
    public void edit(
            @PathParam("username") String username,
            ToDoItem item) {
        item.setUsername(username);
        entityManager.merge(item);
    }

    @DELETE
    @Path("{id}")
    public void remove(@PathParam("id") Long id) {
        ToDoItem item = entityManager.find(ToDoItem.class, id);
        entityManager.remove(item);
    }

    @GET
    @Produces({"application/json"})
    public List<ToDoItem> getAll(@PathParam("username") String username) {
        return entityManager.createNamedQuery(
                "ToDoItem.findByUsername",
                ToDoItem.class)
                .setParameter("username", username).getResultList();
    }
}