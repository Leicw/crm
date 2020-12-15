package com.lcw.crm.workbench.service.imlp;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lcw.crm.exception.DeleteException;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.exception.UpdateException;
import com.lcw.crm.settings.dao.UserDao;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.utils.SqlSessionUtil;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.dao.ActivityDao;
import com.lcw.crm.workbench.dao.ActivityRemarkDao;
import com.lcw.crm.workbench.domain.Activity;
import com.lcw.crm.workbench.domain.ActivityRemark;
import com.lcw.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public boolean save(Activity activity) {
//        调用dao完成添加
        boolean flag = true;
        System.out.println(activity);
        int num = activityDao.save(activity);
        if (num != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {
//        获取参数
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize = Integer.parseInt((String) map.get("pageSize"));

//        使用PageHelper插件分页
        PageHelper.startPage(pageNo,pageSize);
//        调用dao完成查询
        List<Activity> list = activityDao.getActivityListByCondition(map);
        PageInfo<Activity> info = new PageInfo<>(list);

//        封装vo
        PaginationVO<Activity> vo = new PaginationVO<>();
        vo.setTotal(info.getTotal());
        vo.setDataList(list);
        vo.setTotalPages(info.getPages());
        return vo;
    }

    @Override
    public boolean delete(String[] ids) throws DeleteException {
        boolean flag = true;
//      从市场备注表中读取需要删除多少的市场备注,
        int count = activityRemarkDao.findCountByAIds(ids);
//        删除市场备注,如果需要删除的数据为0则不删除
        if (count != 0) {
            int deleteRemarkRes = activityRemarkDao.deleteByAIds(ids);

            if (count != deleteRemarkRes){
                flag = false;
                throw new DeleteException("市场活动备注删除失败");
            }
        }

//        删除市场活动
        int deleteActivityRes = activityDao.delete(ids);

        if (deleteActivityRes != ids.length){
            flag = false;
            throw new DeleteException("删除市场活动失败");
        }

        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String activityId) {
//        查询用户列表
        List<User> userList = userDao.getUserList();
//        查询市场活动
        Activity activity = activityDao.getActivityById(activityId);
//        将用户列表和市场活动封装到map
        Map<String,Object> map = new HashMap<>();
        map.put("activity",activity);
        map.put("userList",userList);

        return map;
    }

    @Override
    public void update(Activity activity) throws UpdateException {
        //        调用dao完成添加
        System.out.println(activity);
        int num = activityDao.update(activity);
        if (num != 1){
            throw new UpdateException("更新错误");
        }
    }

    @Override
    public Map<String, Object> detail(String id) {
//        调用dao
        Activity activity = activityDao.detail(id);
        List<User> userList = userDao.getUserList();
        Map<String,Object> map = new HashMap<>();
        map.put("activity",activity);
        map.put("userList",userList);

        return map;
    }

    @Override
    public List<ActivityRemark> getRemarkList(String activityId) {
//        调用dao完成查询
        List<ActivityRemark> list = activityRemarkDao.getRemarkListByActivityId(activityId);

        return list;
    }

    @Override
    public void deleteRemark(String id) throws DeleteException {
//        调用dao
        int count = activityRemarkDao.deleteRemarkById(id);
        System.out.println(count);
        if (count != 1){
            throw new DeleteException("删除市场活动失败");
        }
    }

    @Override
    public void saveRemark(ActivityRemark activityRemark) throws SaveException {
//        调用dao
        int count = activityRemarkDao.save(activityRemark);

        if (count != 1){
            throw new SaveException("添加市场活动备注失败");
        }

    }

    @Override
    public void updateRemark(ActivityRemark activityRemark) throws UpdateException {
//        调用dao
        int count = activityRemarkDao.updateById(activityRemark);
        if (count != 1){
            throw new UpdateException("更新市场活动备注失败");
        }
    }

    @Override
    public List<Activity> getActivityListByClueId(String id) {

        List<Activity> list = activityDao.getActivityListByClueId(id);
        return list;
    }
}
