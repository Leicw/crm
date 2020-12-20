package com.lcw.crm.workbench.service;

import com.lcw.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactsListByFullName(String fullname);
}
