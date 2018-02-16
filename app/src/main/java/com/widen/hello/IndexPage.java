package com.widen.hello;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class IndexPage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HelloPojo justAnExampleOfUsingGradleSubproject = new HelloPojo("arg1", "arg2");

        String name = request.getParameter("name");
        response.getWriter().print(new MessageGenerator().hello(name));
    }

}
