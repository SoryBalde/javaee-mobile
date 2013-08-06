package org.glassfish.javaee.mobile.server.todo;

import java.util.List;

public interface ToDoItemRepository {

    void create(ToDoItem item);

    void delete(ToDoItem item);

    ToDoItem find(Long id);

    List<ToDoItem> findByUsername(String username);

    void update(ToDoItem item);
}