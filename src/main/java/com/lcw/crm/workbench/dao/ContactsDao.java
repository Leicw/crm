package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int save(Contacts contacts);

    List<Contacts> getContactsListByFullName(String fullname);
}
