package com.lcw.crm.settings.service.impl;

import com.lcw.crm.exception.LoginException;
import com.lcw.crm.settings.dao.UserDao;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.settings.service.UserService;
import com.lcw.crm.utils.DateTimeUtil;
import com.lcw.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String loginIp) throws LoginException {
//         封装登陆数据
        Map<String,Object> map = new HashMap<>();

        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

//        调用dao层的login查询数据
        User user = userDao.login(map);
//        System.out.println(loginIp);
//       判断账号密码是否正确
        if (user == null){
            throw new LoginException("账号或密码错误");
        }
//        判断失效时间
        String nowTime = DateTimeUtil.getSysTime();
        String expireTime = user.getExpireTime();

        if (nowTime.compareTo(expireTime) > 0){
            throw new LoginException("账号已失效");
        }
//        判断账号是否锁定
        if ("0".equals(user.getLockState())){
            throw new LoginException("账号已经锁定");
        }
//        判断ip
        if (!user.getAllowIps().contains(loginIp)){
            throw new LoginException("无权限访问的ip");
        }
//            登陆成功，返回实体类
        return user;
    }

    @Override
    public List<User> getUserList() {
//       调用dao查询
        List<User> list = userDao.getUserList();
//        返回查询结果
        return list;
    }
}
