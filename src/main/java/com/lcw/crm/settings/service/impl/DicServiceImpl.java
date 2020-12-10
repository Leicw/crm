package com.lcw.crm.settings.service.impl;

import com.lcw.crm.settings.dao.DicTypeDao;
import com.lcw.crm.settings.dao.DicValueDao;
import com.lcw.crm.settings.service.DicService;
import com.lcw.crm.utils.SqlSessionUtil;

public class DicServiceImpl implements DicService {
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);
}
