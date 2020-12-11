package com.lcw.crm.web.listener;

import com.lcw.crm.settings.domain.DicValue;
import com.lcw.crm.settings.service.DicService;
import com.lcw.crm.settings.service.impl.DicServiceImpl;
import com.lcw.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
            application.setAttribute(entry.getKey(),entry.getValue());
        }

    }

    public void contextDestroyed(ServletContextEvent event) {

    }

}
