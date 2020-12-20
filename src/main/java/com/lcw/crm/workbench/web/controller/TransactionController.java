package com.lcw.crm.workbench.web.controller;

import com.lcw.crm.exception.SaveException;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.settings.service.UserService;
import com.lcw.crm.settings.service.impl.UserServiceImpl;
import com.lcw.crm.utils.DateTimeUtil;
import com.lcw.crm.utils.PrintJson;
import com.lcw.crm.utils.ServiceFactory;
import com.lcw.crm.utils.UUIDUtil;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.dao.TranDao;
import com.lcw.crm.workbench.domain.Activity;
import com.lcw.crm.workbench.domain.Contacts;
import com.lcw.crm.workbench.domain.Tran;
import com.lcw.crm.workbench.domain.TranHistory;
import com.lcw.crm.workbench.service.ActivityService;
import com.lcw.crm.workbench.service.ContactsService;
import com.lcw.crm.workbench.service.CustomerService;
import com.lcw.crm.workbench.service.TranService;
import com.lcw.crm.workbench.service.imlp.ActivityServiceImpl;
import com.lcw.crm.workbench.service.imlp.ContactsServiceImpl;
import com.lcw.crm.workbench.service.imlp.CustomerServiceImpl;
import com.lcw.crm.workbench.service.imlp.TranServiceImpl;
import org.omg.IOP.TransactionService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TransactionController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/transaction/add.do".equals(path)){
            add(request,response);
        }else if ("/workbench/transaction/getActivityList.do".equals(path)){
            getActivityList(request,response);
        }else if ("/workbench/transaction/getContactList.do".equals(path)){
            getContactList(request,response);
        }else if ("/workbench/transaction/getCustomerName.do".equals(path)){
            getCustomerName(request,response);
        }else if ("/workbench/transaction/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/transaction/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/transaction/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/transaction/showHistoryList.do".equals(path)){
            showHistoryList(request,response);
        }
    }

    private void showHistoryList(HttpServletRequest request, HttpServletResponse response) {
//        接收参数
        String tranId = request.getParameter("tranId");
//        调用服务层
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> list = ts.showHistoryList(tranId);
//        完整可能性的补充
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        for (TranHistory th : list){
//            获取可能性
            th.setPossibility(pMap.get(th.getStage()));
        }

//        输出结果
        PrintJson.printJsonObj(response,list);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        获取参数
        String id = request.getParameter("id");
//        调用服务层
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = ts.selectById(id);
//        前端需要一个possibility 我们扩展实体类里这个属性，然后根据数据字典判断，并封装到实体类
        String possibility = ((Map<String,String>)request.getServletContext().getAttribute("pMap")).get(tran.getStage());
        tran.setPossibility(possibility);


//        转发数据
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);


    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        获取请求的参数
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

//        封装信息，其中客户id为空，需要服务层根据客户名称精确查找
        Tran tran = new Tran();
        tran.setContactsId(contactsId);
        tran.setCreateBy(createBy);
        tran.setId(id);
        tran.setName(name);
        tran.setMoney(money);
        tran.setActivityId(activityId);
        tran.setStage(stage);
        tran.setCreateTime(createTime);
        tran.setType(type);
        tran.setSource(source);
        tran.setNextContactTime(nextContactTime);
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setExpectedDate(expectedDate);
        tran.setOwner(owner);

//        调用服务层
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        try{
            tranService.save(tran,customerName);
//            添加成功，重定向到index，不能使用请求转发，1：没有共享数据，2：需要刷新地址栏
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }catch (SaveException e){
            response.getWriter().print("<h3>"+ e.getMessage() +"</h3>");
        }
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
//        获取请求参数
        String pageNo = request.getParameter("pageNo");
        String pageSize = request.getParameter("pageSize");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String customerId = request.getParameter("customerName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String contactsId = request.getParameter("contactsName");
//        封装信息
        Map<String,String> map = new HashMap<>();
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerId",customerId);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsId",contactsId);
//        调用服务层
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        PaginationVO<Tran> vo = ts.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
//        获取请求的参数
        String name = request.getParameter("name");
//        调用服务层
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<String> list = cs.getCustomerName(name);
//        输出
        PrintJson.printJsonObj(response,list);
    }

    private void getContactList(HttpServletRequest request, HttpServletResponse response) {
//        获取请求参数
        String fullname = request.getParameter("fullname");
//        调用服务层
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> list = cs.getContactsListByFullName(fullname);
//        输出结果
        PrintJson.printJsonObj(response,list);
    }

    private void getActivityList(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        List<Activity> list = as.getActivityByName(name);
        PrintJson.printJsonObj(response,list);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        获取用户列表
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> list = us.getUserList();

//      将用户列表放入请求作用域
        request.setAttribute("userList",list);
//        转发给jsp
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);
    }
}
