package com.lcw.crm.workbench.service.imlp;

import com.lcw.crm.utils.SqlSessionUtil;
import com.lcw.crm.workbench.dao.CustomerDao;
import com.lcw.crm.workbench.service.CustomerService;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public List<String> getCustomerName(String name) {
        List<String> list = customerDao.getCustomerName(name);
        return list;
    }
}
