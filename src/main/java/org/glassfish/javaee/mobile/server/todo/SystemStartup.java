/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.glassfish.javaee.mobile.server.todo;

import java.util.logging.Logger;
import javax.annotation.PostConstruct;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.inject.Inject;

/**
 * Startup, pre-populates the system with data
 * @author Ryan Cuprak
 */
@Startup
@Singleton
public class SystemStartup {
    
    /**
     * Logger
     */
    private static final Logger logger = Logger.getLogger("SystemStartup");
    
    @Inject
    private ToDoItemRepository repository;
    
    @PostConstruct
    public void preload() {
        logger.info("System has started");
        if(repository.findByUsername("rcuprak").isEmpty()) {
            logger.info("Initial record created.");
            ToDoItem item = new ToDoItem("rcuprak","Bike to Tiburon","Bike from SF to Tiburon.",false);
            repository.create(item);
        }
    }
    
}
