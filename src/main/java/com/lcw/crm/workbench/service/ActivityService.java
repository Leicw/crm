package com.lcw.crm.workbench.service;

import com.lcw.crm.exception.DeleteException;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.exception.UpdateException;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.domain.Activity;
import com.lcw.crm.workbench.domain.ActivityRemark;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ActivityService {
    boolean save(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids) throws DeleteException;

    Map<String, Object> getUserListAndActivity(String activityId);

    void update(Activity activity) throws UpdateException;

    Map<String, Object> detail(String id);

    List<ActivityRemark> getRemarkList(String activityId);

    void deleteRemark(String id) throws DeleteException;

    void saveRemark(ActivityRemark activityRemark) throws SaveException;

    void updateRemark(ActivityRemark ar) throws UpdateException;

    List<Activity> getActivityListByClueId(String id);

    List<Activity> getActivityByNameExcludeBund(HashMap<String, String> map);

    List<Activity> getActivityByName(String name);
}
