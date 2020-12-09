package com.lcw.crm.workbench.dao;

import com.lcw.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int findCountByAIds(String[] ids);

    int deleteByAIds(String[] ids);

    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    int deleteRemarkById(String id);

    int save(ActivityRemark activityRemark);

    int updateById(ActivityRemark activityRemark);
}
