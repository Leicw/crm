package com.lcw.crm.settings.service;

import com.lcw.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getDic();
}
