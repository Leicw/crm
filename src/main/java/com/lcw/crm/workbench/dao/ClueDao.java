package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue clue);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    Clue detail(String id);

    int breakBund(String id);

    Clue selectById(String clueId);

    int deleteById(String clueId);
}
