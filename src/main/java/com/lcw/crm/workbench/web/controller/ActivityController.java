package com.lcw.crm.workbench.web.controller;

import com.lcw.crm.exception.DeleteException;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.exception.UpdateException;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.settings.service.UserService;
import com.lcw.crm.settings.service.impl.UserServiceImpl;
import com.lcw.crm.utils.DateTimeUtil;
import com.lcw.crm.utils.PrintJson;
import com.lcw.crm.utils.ServiceFactory;
import com.lcw.crm.utils.UUIDUtil;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.domain.Activity;
import com.lcw.crm.workbench.domain.ActivityRemark;
import com.lcw.crm.workbench.service.ActivityService;
import com.lcw.crm.workbench.service.imlp.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/activity/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if("/workbench/activity/save.do".equals(path)){
            save(request,response);
        }else if("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/activity/delete.do".equals(path)){
            delete(request,response);
        }else if ("/workbench/activity/getUserListAndActivity.do".equals(path)){
            getUserListAndActivity(request,response);
        }else if ("/workbench/activity/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/activity/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/activity/getRemarkList.do".equals(path)){
            getRemarkList(request,response);
        }else if ("/workbench/activity/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if ("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/activity/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
//        获取参数
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
//        封装
        ActivityRemark ar = new ActivityRemark();
        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setEditFlag(editFlag);
        ar.setEditBy(editBy);
        ar.setEditTime(editTime);
//        调用服务层
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Map<String,Object> map = new HashMap<>();
        try{
            as.updateRemark(ar);
            map.put("success",true);
            map.put("remark",ar);
        }catch (UpdateException e){
            map.put("success",false);
            map.put("msg",e.getMessage());
        }
        PrintJson.printJsonObj(response,map);


    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
//        获取参数
        String id = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContent");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "0";
        String activityId = request.getParameter("activityId");
//        封装市场活动
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setCreateBy(createBy);
        activityRemark.setCreateTime(createTime);
        activityRemark.setEditFlag(editFlag);
        activityRemark.setActivityId(activityId);
//        调用服务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        HashMap<String,Object> map = new HashMap<>();
        try{
            activityService.saveRemark(activityRemark);
            map.put("success",true);
            map.put("remark",activityRemark);
        }catch(SaveException e){
            map.put("success",false);
            map.put("msg",e.getMessage());
        }
//        输出
        PrintJson.printJsonObj(response,map);


    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
//        获取请求的参数
        String id = request.getParameter("id");
//        调用服务层
        try{
            ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
            activityService.deleteRemark(id);
            PrintJson.printJsonFlag(response,true);
        }catch (DeleteException e){
            HashMap<String,Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",e.getMessage());
//            输出
            PrintJson.printJsonObj(response,map);
        }
    }

    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
//        获取请求参数
        String activityId = request.getParameter("activityId");
//        调用service层完成业务
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<ActivityRemark> list = activityService.getRemarkList(activityId);
//        将结果输出
        PrintJson.printJsonObj(response,list);


    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        获取信息参数
        String id = request.getParameter("id");
//        调用市场活动服务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Map<String,Object> map = activityService.detail(id);
        List<User> userList = (List<User>) map.get("userList");
        Activity activity = (Activity) map.get("activity");
//        传给v层处理
        request.setAttribute("activity",activity);
        request.setAttribute("userList",userList);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        //        获取请求的参数
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
//        封装信息
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);
//        调用service完成业务

        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        try {
            service.update(activity);
            PrintJson.printJsonFlag(response,true);

        } catch (UpdateException e) {

            Map<String,Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",e.getMessage());
            PrintJson.printJsonObj(response,map);
//            调用处理器已经打印过异常了
//            e.printStackTrace();

        }
    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
//        获取请求参数
        String activityId = request.getParameter("id");
//        调用service完成业务
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Map<String,Object> map = activityService.getUserListAndActivity(activityId);
//        将结果输出
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
//        获取请求的参数
        String[] ids = request.getParameterValues("id");
        System.out.println(ids[0]);
//        调用service执行删除
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = false;
        try {
            flag = service.delete(ids);
        } catch (DeleteException e) {
            e.printStackTrace();
        }
//        输出结果
        PrintJson.printJsonFlag(response,flag);
    }


    private void pageList(HttpServletRequest request, HttpServletResponse response) {
//        读取前端数据
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        Map<String,Object> map = new HashMap<>();
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
//        调用服务层
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        PaginationVO<Activity> vo = activityService.pageList(map);
//        将数据输出
        PrintJson.printJsonObj(response,vo);
    }


    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
//        调用用户的dao与service
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());
//        执行查询操作
        List<User> list = service.getUserList();
//        将查询结果写出
        PrintJson.printJsonObj(response,list);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
//        获取请求的参数
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
//        封装信息
        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
//        调用service完成业务
        ActivityService service = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag = service.save(activity);
//        输出添加的结果
        PrintJson.printJsonFlag(response,flag);

    }
}
