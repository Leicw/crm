package com.lcw.crm.workbench.web.controller;

import com.lcw.crm.exception.DeleteException;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.settings.service.UserService;
import com.lcw.crm.settings.service.impl.UserServiceImpl;
import com.lcw.crm.utils.DateTimeUtil;
import com.lcw.crm.utils.PrintJson;
import com.lcw.crm.utils.ServiceFactory;
import com.lcw.crm.utils.UUIDUtil;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.domain.Activity;
import com.lcw.crm.workbench.domain.Clue;
import com.lcw.crm.workbench.service.ActivityService;
import com.lcw.crm.workbench.service.ClueService;
import com.lcw.crm.workbench.service.imlp.ActivityServiceImpl;
import com.lcw.crm.workbench.service.imlp.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)) {
            getUserList(request,response);
        }else if ("/workbench/clue/save.do".equals(path)) {
            save(request,response);
        }else if ("/workbench/clue/pageList.do".equals(path)) {
            pageList(request,response);
        }else if ("/workbench/clue/detail.do".equals(path)) {
            detail(request,response);
        }else if ("/workbench/clue/getActivityListByClueId.do".equals(path)) {
            getActivityListByClueId(request,response);
        }else if ("/workbench/clue/breakBund.do".equals(path)) {
            breakBund(request,response);
        }
    }

    private void breakBund(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
//        调用服务层
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        Map<String,Object> map = new HashMap<>();
        boolean success = true;

        try{
            cs.breakBund(id);

        }catch (DeleteException e){
            success = false;
            map.put("msg",e.getMessage());
        }

//        输出结果
        map.put("success",success);
        PrintJson.printJsonObj(response,map);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
//        获取参数
        String id = request.getParameter("id");
//        调用市场活动的服务层
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> list = as.getActivityListByClueId(id);
//        将结果输出
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        获取参数
        String id = request.getParameter("id");
//        调用服务层
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = cs.detail(id);
//        转发给jsp
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
       String fullname = request.getParameter("fullname");
       String owner = request.getParameter("owner");
       String company = request.getParameter("company");
       String phone = request.getParameter("phone");
       String mphone = request.getParameter("mphone");
       String state = request.getParameter("state");
       String source = request.getParameter("source");
       String pageNo = request.getParameter("pageNo");
       String pageSize = request.getParameter("pageSize");
        Map<String,Object> map = new HashMap<>();
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("source",source);

//        调用服务层
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        PaginationVO<Clue> vo = cs.pageList(map);

//        将数据输出
        PrintJson.printJsonObj(response,vo);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
//        获取参数
       String id = UUIDUtil.getUUID();
       String fullname = request.getParameter("fullname");
       String appellation = request.getParameter("appellation");
       String owner = request.getParameter("owner");
       String company = request.getParameter("company");
       String job = request.getParameter("job");
       String email = request.getParameter("email");
       String phone = request.getParameter("phone");
       String website = request.getParameter("website");
       String mphone = request.getParameter("mphone");
       String state = request.getParameter("state");
       String source = request.getParameter("source");
       String createBy = ((User)request.getSession().getAttribute("user")).getName();
       String createTime = DateTimeUtil.getSysTime();
       String description = request.getParameter("description");
       String contactSummary = request.getParameter("contactSummary");
       String nextContactTime = request.getParameter("nextContactTime");
       String address = request.getParameter("address");
//       封装信息
        Clue clue = new Clue();
        clue.setAddress(address);
        clue.setWebsite(website);
        clue.setState(state);
        clue.setSource(source);
        clue.setPhone(phone);
        clue.setOwner(owner);
        clue.setNextContactTime(nextContactTime);
        clue.setMphone(mphone);
        clue.setJob(job);
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setEmail(email);
        clue.setDescription(description);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setContactSummary(contactSummary);
        clue.setAppellation(appellation);
        clue.setCompany(company);
//调用服务层
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = true;
        Map<String,Object> map = new HashMap<>();

        try{
            cs.save(clue);

        }catch (SaveException e){
            success = false;
            map.put("msg",e.getMessage());
        }

        map.put("success",success);
        PrintJson.printJsonObj(response,map);

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
//    调用服务层
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
         List<User> list = us.getUserList();
//         输出结果
        PrintJson.printJsonObj(response,list);

    }

}