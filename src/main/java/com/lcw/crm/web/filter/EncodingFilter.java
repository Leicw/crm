package com.lcw.crm.web.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
//       更改post请求协议包重新编码方式
        HttpServletRequest request = (HttpServletRequest)req;
        if("POST".equals(request.getMethod())) {
            req.setCharacterEncoding("utf-8");
        }

        chain.doFilter(req,resp);
    }
}
