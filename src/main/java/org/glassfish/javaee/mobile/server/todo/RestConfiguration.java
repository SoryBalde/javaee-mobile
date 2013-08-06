package org.glassfish.javaee.mobile.server.todo;

import java.util.HashSet;
import java.util.Set;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

@ApplicationPath("resources")
public class RestConfiguration extends Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new HashSet<>();
        addRestResourceClasses(resources);
        return resources;
    }

    private void addRestResourceClasses(Set<Class<?>> resources) {
        resources.add(org.glassfish.javaee.mobile.server.todo.JsonMoxyConfigurationContextResolver.class);
        resources.add(org.glassfish.javaee.mobile.server.todo.ToDoResource.class);
    }
}