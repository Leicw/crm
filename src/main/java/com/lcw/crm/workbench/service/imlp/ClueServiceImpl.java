package com.lcw.crm.workbench.service.imlp;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lcw.crm.exception.DeleteException;
import com.lcw.crm.exception.SaveException;
import com.lcw.crm.settings.dao.UserDao;
import com.lcw.crm.settings.domain.User;
import com.lcw.crm.utils.SqlSessionUtil;
import com.lcw.crm.utils.UUIDUtil;
import com.lcw.crm.vo.PaginationVO;
import com.lcw.crm.workbench.dao.*;
import com.lcw.crm.workbench.domain.*;
import com.lcw.crm.workbench.service.ClueService;

import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);

    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);

    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);


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

    @Override
    public void bund(String clueId, String[] activityIds) throws SaveException {
        for (String activityId:activityIds){
            ClueActivityRelation car = new ClueActivityRelation();
            car.setActivityId(activityId);
            car.setId(UUIDUtil.getUUID());
            car.setClueId(clueId);

            int num = clueActivityRelationDao.save(car);
            if (num != 1){
                throw new SaveException("添加市场活动id为："+ activityId +" 时，失败");
            }
        }
    }

    @Override
    public void convert(String clueId, String createTime, String createBy, Tran tran) throws SaveException, DeleteException {
//        根据线索id查询线索的详细信息
        Clue clue = clueDao.selectById(clueId);

//        根据线索的公司名，查询是否已经有对应的客户
        Customer customer = customerDao.selectByName(clue.getCompany());
//        如果没有客户我们需要创建
        if (customer == null){
            customer = new Customer();
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setOwner(clue.getOwner());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setName(clue.getCompany());
            customer.setId(UUIDUtil.getUUID());
            customer.setDescription(clue.getDescription());
            customer.setCreateTime(createTime);
            customer.setCreateBy(createBy);
            customer.setContactSummary(clue.getContactSummary());
            customer.setAddress(clue.getAddress());
        }
//        将客户保存
        int res1 = customerDao.save(customer);
        if (res1 != 1){
            throw new SaveException("添加客户失败");
        }

//        保存联系人
        Contacts contacts = new Contacts();
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setId(UUIDUtil.getUUID());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        int res2 = contactsDao.save(contacts);
        if (res2 != 1){
            throw new SaveException("添加联系人失败");
        }

//        将市场活动与线索的备注转换为客户备注表和联系人备注表
//        先根据线索id查询备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.selectByClueId(clueId);
//        保存联系人备注
        for (ClueRemark clueRemark : clueRemarkList) {
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setEditFlag("0");
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setCreateBy(createBy);
            int res3 = contactsRemarkDao.save(contactsRemark);
            if (res3 != 1) {
                throw new SaveException("添加联系人备注失败");
            }

//        保存客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setEditFlag("0");
            int res4 = customerRemarkDao.save(customerRemark);
            if (res4 != 1) {
                throw new SaveException("添加客户备注失败");
            }
        }

//        将市场活动与线索的关联关系转为市场活动与联系人的关联
//        查询根据线索id此线索相关联的市场活动联系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.selectByClueId(clueId);
//        保存市场活动与联系人的关联
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            int res5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (res5 != 1) {
                throw new SaveException("添加联系人与市场活动关联失败");
            }
        }

//        添加交易
//        先判断是否需要添加交易
        if (tran != null){
//            完善实体对象
            tran.setSource(clue.getSource());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            tran.setContactSummary(clue.getContactSummary());
            tran.setOwner(clue.getOwner());
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(customer.getId());
//            保存对象
            int res6 = tranDao.save(tran);
            if (res6 != 1) {
                throw new SaveException("添加交易失败");
            }
//           创建一个交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());
            int res7 = tranHistoryDao.save(tranHistory);
            if (res7 != 1) {
                throw new SaveException("添加交易历史失败");
            }
        }

//        删除线索备注
        int res8 = clueRemarkDao.deleteByClueId(clueId);
        if (res8 != clueRemarkList.size()){
            throw new DeleteException("删除线索备注失败");
        }

//        删除线索与市场关联
        int res9 = clueActivityRelationDao.deleteByClueId(clueId);
        if (res9 != clueActivityRelationList.size()){
            throw new DeleteException("删除市场活动与线索关联失败");
        }
//删除线索
        int res10 = clueDao.deleteById(clueId);
        if (res10 != 1){
         throw new DeleteException("删除线索失败");
        }
    }


}
