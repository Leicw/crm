package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran tran);

    List<Tran> getActivityListByCondition(Map<String, String> map);

    Tran selectById(String id);
}
