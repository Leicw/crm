<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() +  request.getContextPath() ;%>
    <base href=<%=basePath%>/><meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">
        $(function(){
            $("#isCreateTransaction").click(function(){
                if(this.checked){
                    $("#create-transaction2").show(200);
                }else{
                    $("#create-transaction2").hide(200);
                }
            });

            //对模态的日历绑定控件
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //    为打开模态的按钮绑定事件
            $("#openSearchModalBtn").click(function () {
                $("#searchActivityModal").modal("show");
            });

        //    为模态的市场活动搜索获取数据
            $("#searchText").keydown(function (event) {
                if (event.keyCode == 13) {
                    $.ajax({
                        url: "workbench/clue/getActivityByName.do",
                        datatype: "json",
                        data: {
                            "name": $.trim($("#searchText").val())
                        },
                        success: function (data) {
                            var html = "";
                            $.each(data, function (i, e) {
                                html += '<tr>';
                                html += '<td><input type="radio" name="check" value="' + e.id + '"/></td>';
                                html += '<td id="' + e.id + '">' + e.name + '</td>';
                                html += '<td>' + e.startDate + '</td>';
                                html += '<td>' + e.endDate + '</td>';
                                html += '<td>' + e.owner + '</td>';
                                html += '</tr>';
                            });
                            $("#activityModalBody").html(html);
                        }
                    })
                }
            });
        //    为选择按钮绑定事件，将选的市场活动id放到隐藏域，name放到搜索框
            $("#checkActivityBtn").click(function () {
                //获取我们选择的市场活动按钮
                var $checked = $("input[name=check]:checked");
                //获取市场活动id
                var id = $(":radio:checked").attr("value");
                //获取市场活动name
                var name = $("#"+id).text();


                $("#activityName").val(name);
                $("#activityId").val(id);

                $("#searchActivityModal").modal("hide");
            });
        //    为转换绑定事件
            $("#convertBtn").click(function () {
            //    判断时候需要创建交易

                if ($("#isCreateTransaction").prop("checked")){
                //    如果创建交易我们使用提交表单的方式
                    $("#transactionForm").submit()
                }else{
                    //不创建交易，我们值需要传一个线索id，用于线索，创建客户，创建联系人
                    window.location = "workbench/clue/convert.do?clueId=${param.id}";
                }

            });
        });
    </script>

</head>
<body>
<!-- 搜索市场活动的模态窗口 -->
<div class="modal fade" id="searchActivityModal" role="dialog" >
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">搜索市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="searchText" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <%--防止模态回车事件提交表单的隐藏域--%>
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
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="activityModalBody">
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

<div id="title" class="page-header" style="position: relative; left: 20px;">
    <h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
</div>
<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
    新建客户：${param.company}
</div>
<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
    新建联系人：${param.fullname}${param.appellation}
</div>
<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
    <input type="checkbox" id="isCreateTransaction"/>
    为客户创建交易
</div>
<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

    <form action="workbench/clue/convert.do" id="transactionForm" method="post">

<%--    用于后端判断是否需要创建交易的标记    --%>
        <input type="hidden" name="flag" value="yes"/>

<%--        用于提交表单时传线索Id的隐藏域--%>
        <input type="hidden" name="clueId" value="${param.id}"/>

        <div class="form-group" style="width: 400px; position: relative; left: 20px;">
            <label for="amountOfMoney">金额</label>
            <input type="text" class="form-control" id="amountOfMoney" name="money">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="tradeName">交易名称</label>
            <input type="text" class="form-control" id="tradeName" name="name">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="expectedClosingDate">预计成交日期</label>
            <input type="text" class="form-control time" id="expectedClosingDate" readonly name="expectedDate">
        </div>
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="stage">阶段</label>
            <select id="stage"  class="form-control" name="stage">
                <c:forEach items="${stageList}" var="sl">
                    <option value="${sl.value}">${sl.text}</option>
                </c:forEach>
                <%--
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
        <div class="form-group" style="width: 400px;position: relative; left: 20px;">
            <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
            <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly >

<%--            存放市场活动id的隐藏域--%>
            <input type="hidden" id="activityId" name="activityId"/>
        </div>
    </form>

</div>

<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
    记录的所有者：<br>
    <b>${param.owner}</b>
</div>
<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
    <input class="btn btn-primary" type="button" value="转换" id="convertBtn">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input class="btn btn-default" type="button" value="取消">
</div>
</body>
</html>