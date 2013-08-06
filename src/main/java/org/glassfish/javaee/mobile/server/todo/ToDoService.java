package org.glassfish.javaee.mobile.server.todo;

import java.util.List;

public interface ToDoService {

    void addToDoItem(String username, ToDoItem item);

    List<ToDoItem> findToDoItemsByUsername(String username);

    void removeToDoItem(String username, Long id);

    void updateToDoItem(String username, ToDoItem item);
}