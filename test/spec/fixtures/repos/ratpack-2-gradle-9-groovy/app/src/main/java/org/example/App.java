package org.example;

import ratpack.core.server.RatpackServer;

public class App {
    public static void main(String... args) throws Exception {
        RatpackServer.start(server -> server
                .handlers(chain -> chain
                        .get(ctx -> ctx.render("Hello Heroku!\n"))
                )
        );
    }
}
