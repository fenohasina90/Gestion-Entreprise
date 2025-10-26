package com.gestion.config;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.LogRecord;
@WebFilter("/*")
public class SessionFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();

        // page qui ne necessitent pas d 'authentification
        if(
                requestURI.endsWith("login") ||
                        requestURI.endsWith("login") ||
                        requestURI.contains("/public/") ||
                        requestURI.endsWith(".css") ||
                        requestURI.endsWith(".js")
        ){
            chain.doFilter(request, response);
            return;
        }

        if (session == null || session.getAttribute("isLoggedIn") == null) {
            httpResponse.sendRedirect("/");
        }
        chain.doFilter(request, response);

    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
