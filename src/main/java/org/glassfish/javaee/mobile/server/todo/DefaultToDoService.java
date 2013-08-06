package org.glassfish.javaee.mobile.server.todo;

import java.util.List;
import javax.ejb.Stateless;
import javax.inject.Inject;

@Stateless
public class DefaultToDoService implements ToDoService {

    @Inject
    private ToDoItemRepository repository;

    @Override
    public void addToDoItem(String username, ToDoItem item) {
        item.setUsername(username);
        repository.create(item);
    }

    @Override
    public void updateToDoItem(String username, ToDoItem item) {
        item.setUsername(username);
        repository.update(item);
    }

    @Override
    public void removeToDoItem(String username, Long id) {
        ToDoItem item = repository.find(id);
        repository.delete(item);
    }

    @Override
    public List<ToDoItem> findToDoItemsByUsername(String username) {
        return repository.findByUsername(username);
    }
}