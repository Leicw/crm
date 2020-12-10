package com.lcw.crm.settings.web.controller;

import com.lcw.crm.exception.LoginException;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.settings.service.UserService;
import com.lcw.crm.settings.service.impl.UserServiceImpl;
import com.lcw.crm.utils.MD5Util;
import com.lcw.crm.utils.PrintJson;
import com.lcw.crm.utils.ServiceFactory;
import javafx.fxml.LoadException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String urlPattern = request.getServletPath();
        if ("/settings/user/login.do".equals(urlPattern)){
            login(request,response);
        }else{

        }
    }

    private void login(HttpServletRequest request,HttpServletResponse response) {
//        获取请求参数
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        String loginIp = request.getRemoteAddr();
//        加密密码
        loginPwd = MD5Util.getMD5(loginPwd);
//        获取服务层代理
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());
//        执行查询
        try{
            User user = service.login(loginAct,loginPwd,loginIp);
//            将用户信息添加到session
            request.getSession().setAttribute("user",user);
//            登陆成功返回结果
            PrintJson.printJsonFlag(response,true);
        }catch (LoginException e){
//            登陆失败返回结果
            Map<String,Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",e.getMessage());
            PrintJson.printJsonObj(response,map);
        }
    }
}
