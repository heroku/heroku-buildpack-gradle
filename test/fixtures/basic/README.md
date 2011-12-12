This quickstart will get you going with Java apps on the Heroku [Cedar][cedar] stack using the [Gradle][gradle] build system and [Jetty][jetty] embedded web server.

Sample code is available on [github][this-github] along with [this article][this-article-github]. Edits and enhancements are welcome. Just fork the repository, make your changes and send us a pull request.

## Prerequisites

* Basic Java knowledge, including an installed version of the JVM.
* Basic Gradle knowledge, including an installed version of [Gradle][gradle] (1.0-milestone-5 or later).
* Your application must run on the [OpenJDK][openjdk] version 6.
* A Heroku user account.  [Signup is free and instant.][signup]

## Local Workstation Setup

We'll start by setting up your local workstation with the Heroku command-line client and the Git revision control system; and then logging into Heroku to upload your `ssh` public key.  If you've used Heroku before and already have a working local setup, skip to the next section.

<table>
  <tr>
    <th>If you have...</th>
    <th>Install with...</th>
  </tr>
  <tr>
    <td>Mac OS X</td>
    <td style="text-align: left"><a href="http://toolbelt.herokuapp.com/osx/download">Download OS X package</a></td>
  </tr>
  <tr>
    <td>Windows</td>
    <td style="text-align: left"><a href="http://toolbelt.herokuapp.com/windows/download">Download Windows .exe installer</a></td>
  </tr>
  <tr>
    <td>Ubuntu Linux</td>
    <td style="text-align: left"><a href="http://toolbelt.herokuapp.com/linux/readme"><code>apt-get</code> repository</a></td>
  </tr>
  <tr>
    <td>Other</td>
    <td style="text-align: left"><a href="http://assets.heroku.com/heroku-client/heroku-client.tgz">Tarball</a> (add contents to your <code>$PATH</code>)</td>
  </tr>
</table>

Once installed, you'll have access to the `heroku` command from your command shell.  Log in using the email address and password you used when creating your Heroku account:

    :::term
    $ heroku login
    Enter your Heroku credentials.
    Email: adam@example.com
    Password: 
    Could not find an existing public key.
    Would you like to generate one? [Yn] 
    Generating new SSH public key.
    Uploading ssh public key /Users/adam/.ssh/id_rsa.pub

Press enter at the prompt to upload your existing `ssh` key or create a new one, used for pushing code later on.

## Write Your App
    
We will be creating a completely standard Java application that serves web requests using the [Servlet API][servlet] and the embedded Jetty web server.

First create a class that implements a simple Servlet. For the purpose of this example, we'll also create the main method in this class.

### src/main/java/HelloWorld.java

    :::java
    import java.io.IOException;
    import javax.servlet.ServletException;
    import javax.servlet.http.*;
    import org.eclipse.jetty.server.Server;
    import org.eclipse.jetty.servlet.*;

    public class HelloWorld extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws ServletException, IOException {
            resp.getWriter().print("Hello from Java!\n");
        }

        public static void main(String[] args) throws Exception{
            Server server = new Server(Integer.valueOf(System.getenv("PORT")));
            ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
            context.setContextPath("/");
            server.setHandler(context);
            context.addServlet(new ServletHolder(new HelloWorld()),"/*");
            server.start();
            server.join();   
        }
    }

## Set up the build

Create a Gradle build file in your project root. The default tasks will be run by Heroku to build your app:

### build.gradle

    apply plugin:'java'
    apply plugin:'application'

    mainClassName = "HelloWorld"
    applicationName = "app"

    repositories {
        mavenCentral()
    }

    dependencies {
        compile 'org.eclipse.jetty:jetty-servlet:7.4.5.v20110725'
        compile 'javax.servlet:servlet-api:2.5'
    }

    task stage(dependsOn: ['clean', 'installApp'])

Prevent build artifacts from going into revision control by creating this file:

### .gitignore

    :::term
    build
    .gradle

## Build Your App

Build your app locally:

    :::term
    $ gradle stage

## Declare Process Types With Foreman/Procfile

To run your web process, you need to declare what command to use.  We'll use `Procfile` to declare how our web process type is run. The `application` plugin takes care of generating a run script, `build/install/app/bin/app`, which we'll use to start the web app.

Here's what the `Procfile` looks like:

    :::term
    web: ./build/install/app/bin/app

Now that you have a `Procfile`, you can start your application with [Foreman][foreman]:

    :::term
    $ foreman start
    11:01:26 web.1     | started with pid 68657
    11:01:27 web.1     | 2011-10-13 11:01:27.033:INFO:oejs.Server:jetty-7.5.3.v20111011
    11:01:27 web.1     | 2011-10-13 11:01:27.229:INFO:oejsh.ContextHandler:started o.e.j.s.ServletContextHandler{/,null}
    11:01:27 web.1     | 2011-10-13 11:01:27.269:INFO:oejs.AbstractConnector:Started SelectChannelConnector@0.0.0.0:5000 STARTING
    
Your app will come up on port 5000, the default port set by Foreman. Test that it's working with `curl` or a web browser, then Ctrl-C to exit.

## Store Your App in Git

We now have the three major components of our app: build configuration and dependencies in `build.gradle`, process types in `Procfile`, and our application source in `src/main/java/HelloWorld.java`.  Let's put it into Git:

    :::term
    $ git init
    $ git add .
    $ git commit -m "init"

## Deploy to Heroku/Cedar

Create the app on the Cedar stack:

    :::term
    $ heroku create -s cedar
    Creating evening-sky-2099... done, stack is cedar
    http://evening-sky-2099.herokuapp.com/ | git@heroku.com:evening-sky-2099.git

Deploy your code:

    :::term
    $ git push heroku master
    Counting objects: 18, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (5/5), done.
    Writing objects: 100% (10/10), 1.59 KiB, done.
    Total 10 (delta 2), reused 0 (delta 0)

    -----> Heroku receiving push
    -----> Java/Gradle app detected
    -----> Installing gradle-1.0-milestone-5..... done
           (Use the Gradle Wrapper if you want to use a different gradle version)
    -----> executing gradle -I /tmp/asdre342qfad/opt/init.gradle stage
           :compileJava
           Download http://s3pository.heroku.com/jvm/org/eclipse/jetty/jetty-servlet/7.5.3.v20111011/jetty-servlet-7.5.3.v20111
           ...
           :processResources UP-TO-DATE
           :classes
           :jar
           :startScripts
           :installApp
       
           BUILD SUCCESSFUL
       
           Total time: 20.534 secs
    -----> Discovering process types
           Procfile declares types -> web
    -----> Compiled slug size is 936K
    -----> Launching... done, v5
           http://blazing-planet-4614.herokuapp.com deployed to Heroku

Now, let's check the state of the app's processes:

    :::term
    $ heroku ps
    Process       State               Command
    ------------  ------------------  ------------------------------
    web.1         up for 1m           ./build/install/app/bin/app

The web process is up.  Review the logs for more information:

    :::term
    $ heroku logs
    2011-10-13T18:06:23+00:00 heroku[api]: Deploy 7c70d13 by jesper@heroku.com
    2011-10-13T18:06:23+00:00 heroku[api]: Release v5 created by jesper@heroku.com
    2011-10-13T18:06:24+00:00 heroku[slugc]: Slug compilation finished
    2011-10-13T18:06:43+00:00 heroku[web.1]: Unidling
    2011-10-13T18:06:43+00:00 heroku[web.1]: State changed from down to created
    2011-10-13T18:06:43+00:00 heroku[web.1]: State changed from created to starting
    2011-10-13T18:06:44+00:00 heroku[web.1]: Starting process with command `./build/install/app/bin/app`
    2011-10-13T18:06:45+00:00 app[web.1]: 2011-10-13 18:06:45.198:INFO:oejs.Server:jetty-7.5.3.v20111011
    2011-10-13T18:06:45+00:00 app[web.1]: 2011-10-13 18:06:45.258:INFO:oejsh.ContextHandler:started o.e.j.s.ServletContextHandler{/,null}
    2011-10-13T18:06:45+00:00 app[web.1]: 2011-10-13 18:06:45.293:INFO:oejs.AbstractConnector:Started SelectChannelConnector@0.0.0.0:27922 STARTING
    2011-10-13T18:06:46+00:00 heroku[web.1]: State changed from starting to up

Looks good.  We can now visit the app with `heroku open`.

[cedar]: http://devcenter.heroku.com/articles/cedar
[gradle]: http://gradle.org
[servlet]: http://www.oracle.com/technetwork/java/javaee/servlet/index.html
[jetty]: http://eclipse.org/jetty/
[this-github]: https://github.com/heroku/devcenter-gradle
[this-article-github]: https://github.com/heroku/devcenter-gradle/blob/master/README.md
[openjdk]: http://openjdk.java.net/
[signup]: https://api.heroku.com/signup
[foreman]: http://blog.daviddollar.org/2011/05/06/introducing-foreman.html
