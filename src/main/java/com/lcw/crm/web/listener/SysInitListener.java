package com.lcw.crm.web.listener;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lcw.crm.settings.domain.DicValue;
import com.lcw.crm.settings.service.DicService;
import com.lcw.crm.settings.service.impl.DicServiceImpl;
import com.lcw.crm.utils.PrintJson;
import com.lcw.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.IOException;
import java.util.*;

public class SysInitListener implements ServletContextListener{

    // Public constructor is required by servlet spec
    public SysInitListener() {
    }


    public void contextInitialized(ServletContextEvent event) {
//处理数据字典
        ServletContext application = event.getServletContext();
        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());
        Map<String, List<DicValue>> map = ds.getDic();

//        将数据字典放在全局作用域对象
        Set<Map.Entry<String,List<DicValue>>> set = map.entrySet();
        for (Map.Entry<String,List<DicValue>> entry :set){
            application.setAttribute(entry.getKey() + "List",entry.getValue());
        }

//        将阶段对应的可能性放入字典
        ResourceBundle bundle = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> ite = bundle.getKeys();
        HashMap<String,String> pMap = new HashMap<>();
        while (ite.hasMoreElements()){
            String key = ite.nextElement();
            String value = bundle.getString(key);

            pMap.put(key,value);
        }
//解析为json
        ObjectMapper om = new ObjectMapper();
        String json = "";
        try {
            json = om.writeValueAsString(pMap);
        } catch (IOException e) {
            e.printStackTrace();
        }
//保存json,之所以有两个是使用了两种方式，一个页面生成json对象前端判断，一个后端取出后端自己判断
        event.getServletContext().setAttribute("possibilityJson",json);
//保存集合
        event.getServletContext().setAttribute("pMap",pMap);


    }

    public void contextDestroyed(ServletContextEvent event) {

    }

}
