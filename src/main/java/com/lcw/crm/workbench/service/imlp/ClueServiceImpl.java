package com.lcw.crm.workbench.service.imlp;

import com.lcw.crm.utils.SqlSessionUtil;
import com.lcw.crm.workbench.dao.ClueDao;
import com.lcw.crm.workbench.service.ClueService;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);

}
