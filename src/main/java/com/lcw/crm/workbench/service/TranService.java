package com.lcw.crm.workbench.service;

import com.lcw.crm.exception.SaveException;
import com.lcw.crm.exception.UpdateException;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.domain.Tran;
import com.lcw.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    PaginationVO<Tran> pageList(Map<String, String> map);

    void save(Tran tran, String customerName) throws SaveException;

    Tran selectById(String id);

    List<TranHistory> showHistoryList(String tranId);

    void changeStage(Tran tran) throws UpdateException, SaveException;

    Map<String,Object> getCharts();
}
