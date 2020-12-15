package com.lcw.crm.workbench.service;

import com.lcw.crm.exception.DeleteException;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.domain.Activity;
import com.lcw.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    void save(Clue clue) throws SaveException;

    PaginationVO<Clue> pageList(Map<String, Object> map);

    Clue detail(String id);

    void breakBund(String id) throws DeleteException;
}
