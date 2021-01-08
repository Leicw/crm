package com.lcw.crm.workbench.service.imlp;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.exception.UpdateException;
import com.lcw.crm.utils.DateTimeUtil;
import com.lcw.crm.utils.SqlSessionUtil;
import com.lcw.crm.utils.UUIDUtil;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.dao.CustomerDao;
import com.lcw.crm.workbench.dao.TranDao;
import com.lcw.crm.workbench.dao.TranHistoryDao;
import com.lcw.crm.workbench.domain.Customer;
import com.lcw.crm.workbench.domain.Tran;
import com.lcw.crm.workbench.domain.TranHistory;
import com.lcw.crm.workbench.service.TranService;
import org.omg.PortableServer.LIFESPAN_POLICY_ID;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    @Override
    public PaginationVO<Tran> pageList(Map<String, String> map) {
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize = Integer.parseInt((String) map.get("pageSize"));

        PageHelper.startPage(pageNo,pageSize);

        List<Tran> list = tranDao.getActivityListByCondition(map);

        PageInfo<Tran> info = new PageInfo<>(list);
        PaginationVO<Tran> paginationVO = new PaginationVO<>();
        paginationVO.setTotalPages(info.getPages());
        paginationVO.setTotal(info.getTotal());
        paginationVO.setDataList(list);

        return paginationVO;
    }

    @Override
    public void save(Tran tran, String customerName) throws SaveException {
//        判断客户是否已经存在
        Customer cu = customerDao.selectByName(customerName);
//        如果不存在，新建一个
        if (cu == null){
            cu = new Customer();
            cu.setContactSummary(tran.getContactSummary());
            cu.setOwner(tran.getOwner());
            cu.setCreateBy(tran.getCreateBy());
            cu.setCreateTime(DateTimeUtil.getSysTime());
            cu.setDescription(tran.getDescription());
            cu.setId(UUIDUtil.getUUID());
            cu.setName(customerName);
            cu.setNextContactTime(tran.getNextContactTime());

            int res1 = customerDao.save(cu);
            if (res1 != 1){
                throw new SaveException("新建客户失败");
            }
        }

//添加交易,添加前需要把客户的id封装到交易
        tran.setCustomerId(cu.getId());
        int res2 = tranDao.save(tran);
        if (res2 != 1){
            throw new SaveException("新建交易失败");
        }

//        添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setStage(tran.getStage());
        int res3 = tranHistoryDao.save(tranHistory);
        if (res3 != 1){
            throw new SaveException("新建交易历史失败");
        }
    }

    @Override
    public Tran selectById(String id) {
        Tran tran = tranDao.selectById(id);
        return tran;
    }

    @Override
    public List<TranHistory> showHistoryList(String tranId) {
        List<TranHistory> list = tranHistoryDao.getListByTranId(tranId);
        return list;
    }

    @Override
    public void changeStage(Tran tran) throws UpdateException, SaveException {
//        修改交易表的信息
        int res1 = tranDao.changeStage(tran);
        if (res1 != 1){
            throw new UpdateException("更新交易数据失败");
        }
//创建一个交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setStage(tran.getStage());
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setCreateTime(tran.getEditTime());
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setTranId(tran.getId());

        int res2 = tranHistoryDao.save(tranHistory);
        if (res2 != 1){
            throw new SaveException("添加交易历史失败");
        }
    }

    @Override
    public Map<String,Object> getCharts() {
        int total = tranDao.getTotal();

        List<Map<String,String>> list = tranDao.getCountGroupStage();

        Map<String,Object> map = new HashMap<>();
        map.put("total",total);
        map.put("dataList",list);

        return map;
    }


}
