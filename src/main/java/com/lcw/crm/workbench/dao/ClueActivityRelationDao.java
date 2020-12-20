package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {

    int save(ClueActivityRelation car);

    List<ClueActivityRelation> selectByClueId(String clueId);

    int deleteByClueId(String clueId);
}
