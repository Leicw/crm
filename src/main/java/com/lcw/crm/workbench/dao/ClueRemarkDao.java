package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {


    List<ClueRemark> selectByClueId(String clueId);

    int deleteByClueId(String clueId);
}
