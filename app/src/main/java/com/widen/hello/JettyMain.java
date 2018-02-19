package com.widen.hello;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.util.log.Log;
import org.eclipse.jetty.webapp.WebAppContext;

import java.nio.file.Paths;

public class JettyMain {

    public static void main(String[] args) throws Exception {
        Log.getLog().info("Deploying in WAR-exploded mode (working directory = '{}')", Paths.get(".").toAbsolutePath().normalize().toString());

        Server server = new Server();
        ServerConnector http = new ServerConnector(server);
        http.setPort(8080);
        server.addConnector(http);

        WebAppContext context = new WebAppContext();
        context.setServer(server);
        context.setWar("webapp");

        server.setHandler(context);

        server.start();
        server.join();
    }

}
