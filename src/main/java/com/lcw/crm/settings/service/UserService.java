package com.lcw.crm.settings.service;

import com.lcw.crm.exception.LoginException;
import com.lcw.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String loginIp) throws LoginException;

    List<User> getUserList();
}
