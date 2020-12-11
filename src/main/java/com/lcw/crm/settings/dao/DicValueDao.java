package com.lcw.crm.settings.dao;

import com.lcw.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getListByTypeCode(String code);
}
