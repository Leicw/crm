package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {

    Customer selectByName(String company);

    int save(Customer customer);

    List<String> getCustomerName(String name);
}
