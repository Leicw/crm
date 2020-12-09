package com.lcw.crm.settings.dao;

import com.lcw.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {

    User login(Map<String, Object> map);

    List<User> getUserList();
}
