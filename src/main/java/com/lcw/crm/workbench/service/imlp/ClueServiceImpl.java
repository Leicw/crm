package com.lcw.crm.workbench.service.imlp;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lcw.crm.exception.DeleteException;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.settings.dao.UserDao;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.utils.SqlSessionUtil;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.dao.ClueDao;
import com.lcw.crm.workbench.domain.Activity;
import com.lcw.crm.workbench.domain.Clue;
import com.lcw.crm.workbench.service.ClueService;

import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);


    @Override
    public void save(Clue clue) throws SaveException {
        int num = clueDao.save(clue);

        if (num != 1){
            throw new SaveException("保存线索失败");
        }
    }

    @Override
    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        //        获取参数
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize = Integer.parseInt((String) map.get("pageSize"));

//        使用PageHelper插件分页
        PageHelper.startPage(pageNo,pageSize);
//        调用dao完成查询
        List<Clue> list = clueDao.getClueListByCondition(map);
        PageInfo<Clue> info = new PageInfo<>(list);

//        封装vo
        PaginationVO<Clue> vo = new PaginationVO<>();
        vo.setTotal(info.getTotal());
        vo.setDataList(list);
        vo.setTotalPages(info.getPages());

        return vo;

    }

    @Override
    public Clue detail(String id) {

        Clue c = clueDao.detail(id);

        return c;
    }

    @Override
    public void breakBund(String id) throws DeleteException {
//        调用dao
        int num = clueDao.breakBund(id);
        if (num != 1){
            throw new DeleteException("删除关系表数据失败");
        }
    }
}
