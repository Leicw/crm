package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.Activity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity activity);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int delete(String[] ids);

    Activity getActivityById(String activityId);

    int update(Activity activity);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String id);

    List<Activity> getActivityByNameExcludeBund(HashMap<String, String> map);

    List<Activity> getActivityByName(String name);
}
