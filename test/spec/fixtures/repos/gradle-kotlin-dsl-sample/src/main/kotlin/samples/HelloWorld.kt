package samples

import org.eclipse.jetty.server.Server
import org.eclipse.jetty.servlet.ServletContextHandler
import org.eclipse.jetty.servlet.ServletHolder

import javax.servlet.ServletException
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import java.io.IOException

class HelloWorld() : HttpServlet() {

    @Throws(ServletException::class, IOException::class)
    override protected fun doGet(req: HttpServletRequest, resp: HttpServletResponse) {
        resp.getWriter().print("Hello from Kotlin")
    }
}

@Throws(Exception::class)
fun main(args: Array<String>) {
    val port = if (System.getenv("PORT") == null) "8080" else System.getenv("PORT")
    val server = Server(Integer.valueOf(port))
    val context = ServletContextHandler(ServletContextHandler.SESSIONS)
    context.setContextPath("/")
    server.setHandler(context)
    context.addServlet(ServletHolder(HelloWorld()), "/*")
    server.start()
    server.join()
}
