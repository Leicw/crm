package com.lcw.crm.settings.service.impl;

import com.lcw.crm.settings.dao.DicTypeDao;
import com.lcw.crm.settings.dao.DicValueDao;
import com.lcw.crm.settings.domain.DicType;
import com.lcw.crm.settings.domain.DicValue;
import com.lcw.crm.settings.service.DicService;
import com.lcw.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);

    @Override
    public Map<String, List<DicValue>> getDic() {
//        获取每个类型的实体的集合
        List<DicType> dicTypeList = dicTypeDao.getList();

//        获取每个类型对象对应实体的集合
        Map<String,List<DicValue>> map = new HashMap<>();
        for (DicType e : dicTypeList){
            String code = e.getCode();
            List<DicValue> dicValueList = dicValueDao.getListByTypeCode(code);

//            将字典值放入放入map封装
            map.put(code,dicValueList);
        }


        return map;
    }
}
