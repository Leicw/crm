package com.lcw.crm.web.filter;

import com.lcw.crm.settings.domain.User;
import com.lcw.crm.utils.SqlSessionUtil;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
//        对象响应对象强转
        HttpServletRequest request = (HttpServletRequest)req;
        HttpServletResponse response = (HttpServletResponse)resp;
//        获取请求的地址
        String path = request.getServletPath();
        String projectName = request.getContextPath();
//        判断是否请求的是登陆相关
        if (path.contains("login") || projectName.equals(path)){
            chain.doFilter(req, resp);
        }else{
//            如果不是登陆相关，判断session里是否有user
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null){
                chain.doFilter(req, resp);
            }else {
                System.out.println(projectName + "/login.jsp");
                response.sendRedirect(projectName + "/login.jsp");
            }
        }
    }

    public void init(FilterConfig config) throws ServletException {

    }

}
