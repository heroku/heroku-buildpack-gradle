package my.app;

import ratpack.core.server.RatpackServer;

public class Main {
 public static void main(String... args) throws Exception {
   RatpackServer.start(server -> server 
     .handlers(chain -> chain
       .get(ctx -> ctx.render("Hello Heroku!\n"))
     )
   );
 }
}
