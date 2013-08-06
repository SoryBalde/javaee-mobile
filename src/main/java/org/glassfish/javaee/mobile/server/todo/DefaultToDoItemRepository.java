package org.glassfish.javaee.mobile.server.todo;

import java.io.Serializable;
import java.util.List;
import javax.enterprise.context.RequestScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@RequestScoped // Remove this, it should be default scoped.
public class DefaultToDoItemRepository
        implements ToDoItemRepository, Serializable {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void create(ToDoItem item) {
        entityManager.persist(item);
    }

    @Override
    public ToDoItem find(Long id) {
        return entityManager.find(ToDoItem.class, id);
    }

    @Override
    public List<ToDoItem> findByUsername(String username) {
        return entityManager.createNamedQuery(
                "ToDoItem.findByUsername",
                ToDoItem.class)
                .setParameter("username", username).getResultList();
    }

    @Override
    public void update(ToDoItem item) {
        entityManager.merge(item);
    }

    @Override
    public void delete(ToDoItem item) {
        entityManager.remove(item);
    }
}