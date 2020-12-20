package com.lcw.crm.workbench.service.imlp;

import com.lcw.crm.utils.SqlSessionUtil;
import com.lcw.crm.workbench.dao.ContactsDao;
import com.lcw.crm.workbench.domain.Contacts;
import com.lcw.crm.workbench.service.ContactsService;

import java.util.List;

public class ContactsServiceImpl implements ContactsService {
    ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);

    @Override
    public List<Contacts> getContactsListByFullName(String fullname) {
        List<Contacts> list = contactsDao.getContactsListByFullName(fullname);

        return list;
    }
}
