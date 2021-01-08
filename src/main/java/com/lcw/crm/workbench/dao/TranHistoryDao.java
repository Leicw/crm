package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranHistoryDao {

    int save(TranHistory tranHistory);

    List<TranHistory> getListByTranId(String tranId);

}
