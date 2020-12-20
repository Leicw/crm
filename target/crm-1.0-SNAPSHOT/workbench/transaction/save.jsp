<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() +  request.getContextPath() ;%>
    <base href=<%=basePath%>/>
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
<%--        获取数据字典里的可能性--%>
        var json = ${possibilityJson};


        $(function () {
            //对下次联系时间添加时间控件
            $(".timeTop").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            //对预计成交日期时间添加时间控件
            $(".timeBott").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

        //    根据阶段填写可能性
            $("#create-transactionStage").change(function () {
                //获取当前选中了哪个阶段
                var stage = $("#create-transactionStage").val();

                //获取当前阶段对应的可能性
                var possibility = json[stage];

                //对可能性文本框填写
                $("#create-possibility").val(possibility)

            });


            //    开打查找市场活动模态
            $("#activityModelBtn").click(function () {
                $("#findMarketActivity").modal("show");
            });
        //    为市场活动源获取信息
            $("#queryActivityText").keydown(function (event) {
               if (event.keyCode == 13){
                   $.ajax({
                       url:"workbench/transaction/getActivityList.do",
                       datatype:"json",
                       data:{
                           "name":$.trim($("#queryActivityText").val())
                       },
                       success:function (data) {
                           var html = "";
                           $.each(data,function (i,e) {
                               html += '<tr>';
                               html += '<td><input type="radio" name="aCheck" value="'+ e.id +'" /></td>';
                               html += '<td id="'+ e.id +'">'+ e.name +'</td>';
                               html += '<td>'+ e.startDate +'</td>';
                               html += '<td>'+ e.endDate +'</td>';
                               html += '<td>'+ e.owner +'</td>';
                               html += '</tr>';
                           });
                           $("#activityBody").html(html);
                       }
                   })
               }
            });
        //选择市场活动按钮
            $("#checkActivityBtn").click(function () {
                //获取选择的市场活动name和id
                var $check = $("input[name=aCheck]:checked");
                var id = $check.val();
                var name = $("#"+id).text();
                //将信息保存在隐藏域
                $("#create-activitySrc").val(name);
                $("#create-activityId").val(id);
                //关闭模态
                $("#findMarketActivity").modal("hide");
            });

        //    打开查找联系人名称模态
            $("#contactsModalBtn").click(function () {
                $("#findContacts").modal("show");
            });
            //    为联系人名称获取信息
            $("#queryContactsText").keydown(function (event) {
                if (event.keyCode == 13){
                    $.ajax({
                        url:"workbench/transaction/getContactList.do",
                        datatype:"json",
                        data:{
                            "fullname":$.trim($("#queryContactsText").val())
                        },
                        success:function (data) {
                            var html = "";
                            $.each(data,function (i,e) {
                                html += '<tr>';
                                html += '<td><input type="radio" name="cCheck" value="'+ e.id +'"/></td>';
                                html += '<td id="'+ e.id +'">'+ e.fullname +'</td>';
                                html += '<td>'+ e.email +'</td>';
                                html += '<td>'+ e.mphone +'</td>';
                                html += '</tr>';
                            });
                            $("#contactsBody").html(html);
                        }
                    })
                }
            });
            //选择市场活动按钮
            $("#checkContactsBtn").click(function () {
                //获取选择的市场活动name和id
                var $check = $("input[name=cCheck]:checked");
                var id = $check.val();
                var fullname = $("#"+id).text();
                //将信息保存在隐藏域
                $("#create-contactsFullName").val(fullname);
                $("#create-contactsId").val(id);
                //关闭模态
                $("#findContacts").modal("hide");
            });

        //    客户名称的自动补全
            $("#create-customerName").typeahead({
                //query是文本框的value，process是一个展现数据回调，形参字符串数组
                source: function (query, process) {
                    $.post(
                        "workbench/transaction/getCustomerName.do",
                        { "name" : query },
                        function (data) {
                            //alert(data);

                            process(data);
                        },
                        "json"
                    );
                },
                delay: 1500
            });
        //    创建交易
            $("#saveBtn").click(function () {
            //    提交表单信息
                $("#saveForm").submit();
            });
        })
    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="queryActivityText">
<%--                            禁止模态表单自动提交的隐藏域--%>
                            <input type='text' style='display:none'/>
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activityBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="checkActivityBtn">选择</button>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询" id="queryContactsText">
                            <%--                            禁止模态表单自动提交的隐藏域--%>
                            <input type='text' style='display:none'/>
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactsBody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="checkContactsBtn">选择</button>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;" action="workbench/transaction/save.do" id="saveForm">
    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner" name="owner">
                <c:forEach var="u" items="${userList}">
                    <option value="${u.id}" ${user.id eq u.id?"selected":""}>${u.name}</option>
                </c:forEach>
                <%--<option>zhangsan</option>
                <option>lisi</option>
                <option>wangwu</option>--%>
            </select>
        </div>
        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney" name="money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName" name="name">
        </div>
        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control timeBott" id="create-expectedClosingDate" name="expectedDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建" name="customerName">
        </div>
        <label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionStage" name="stage">
                <c:forEach items="${stageList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
                <%--<option></option>
                <option>资质审查</option>
                <option>需求分析</option>
                <option>价值建议</option>
                <option>确定决策者</option>
                <option>提案/报价</option>
                <option>谈判/复审</option>
                <option>成交</option>
                <option>丢失的线索</option>
                <option>因竞争丢失关闭</option>--%>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType" name="type">
                <option></option>
                <c:forEach items="${transactionTypeList}" var="tl">
                    <option value="${tl.value}">${tl.text}</option>
                </c:forEach>
                <%--<option></option>
                <option>已有业务</option>
                <option>新业务</option>--%>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility" disabled>
        </div>
    </div>

    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource" name="source">
                <option></option>
                <c:forEach items="${sourceList}" var="sc">
                    <option value="${sc.value}">${sc.text}</option>
                </c:forEach>
                <%--<option></option>
                <option>广告</option>
                <option>推销电话</option>
                <option>员工介绍</option>
                <option>外部介绍</option>
                <option>在线商场</option>
                <option>合作伙伴</option>
                <option>公开媒介</option>
                <option>销售邮件</option>
                <option>合作伙伴研讨会</option>
                <option>内部研讨会</option>
                <option>交易会</option>
                <option>web下载</option>
                <option>web调研</option>
                <option>聊天</option>--%>
            </select>
        </div>
        <label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="activityModelBtn"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activitySrc" readonly/>
            <%--            存放市场活动id的隐藏域--%>
            <input type="hidden" id="create-activityId" name="activityId"/>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsFullName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="contactsModalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactsFullName" readonly>
            <%--            存放联系人名称活动id的隐藏域--%>
            <input type="hidden" id="create-contactsId" name="contactsId"/>
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control timeTop" id="create-nextContactTime" name="nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>