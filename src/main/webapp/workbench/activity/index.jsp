<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() +  request.getContextPath() ;%>
<!DOCTYPE html>
<html>
<head>
    <base href=<%=basePath%>/>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />


    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        $(function(){

            //    对的日期添加日历控件
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            //    对日历控件所选单位为只读
            $(".time").attr("readonly",true);

            //    页面加载完毕，加载一次活动列表，默认第一页，两条数据
            pageList(1,2);


            $("#addBtn").click(function () {
                //为模态窗口获取数据
                $.ajax({
                    url: "workbench/activity/getUserList.do",
                    datatype: "json",
                    success: function (data) {
                        var html = "";
                        $.each(data, function (i, e) {
                            html += "<option value='" + e.id + "'>" + e.name + "</option>"
                        });
                        //    为模态的用户添加选项
                        $("#create-marketActivityOwner").html(html);
                        //    用户的选项是默认选项
                        var userId = "${user.id}";
                        $("#create-marketActivityOwner").val(userId);
                    }
                });
                //展现模态窗口
                $("#createActivityModal").modal(true);
            });

        //    执行添加请求
            $("#saveBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/save.do",
                    type:"post",
                    datatype:"json",
                    data:{
                        "owner":$.trim($("#create-marketActivityOwner").val()),
                        "name":$.trim($("#create-marketActivityName").val()),
                        "startDate":$.trim($("#create-startTime").val()),
                        "endDate":$.trim($("#create-endTime").val()),
                        "cost":$.trim($("#create-cost").val()),
                        "description":$.trim($("#create-describe").val())
                    },
                    success:function (data) {
                        if (data.success){

                        //    更新市场活动，保存数据我们，打开第一页，维持展现的条数
                            pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                        //    关闭模态窗口并清空模态的信息
                            $("#addActivityForm")[0].reset();
                            $("#createActivityModal").modal("hide");

                        }else {
                            alert("添加市场活动失败")
                        }
                    }
                })
            });


        /*//    对查询的日历控件所选单位为只读
        //     $(".time-query").attr("readonly",true);
            //    对查询的日期添加日历控件
            $(".time-query").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });*/

        //    给查询按钮绑定事件
            $("#queryBtn").click(function () {
                //将查询的数据保存到隐藏域，防止只填了数据未点击查询就根据数据查信息
                $("#hidden-name").val($.trim($("#query-name").val()));
                $("#hidden-owner").val($.trim($("#query-owner").val()));
                $("#hidden-startDate").val($.trim($("#query-startDate").val()));
                $("#hidden-endDate").val($.trim($("#query-endDate").val()));

                //查询后应该调到第一页，维持条数
                pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

            });

        //    按钮的全选处理
            $("#checkAll").click(function () {
                $("input[name=check]").prop("checked",this.checked);
            });
            //传统的方式无法为动态生成的按钮绑定事件，只能用on
            $("#activityTableBody").on("click",$("input[name=check]"),function () {
                $("#checkAll").prop("checked",$("input[name=check]").length == $("input[name=check]:checked").length)
            });


        //  为删除操作绑定事件
            $("#deleteBtn").click(function () {
                var $checkedBtn = $("input[name=check]:checked");

                if ($checkedBtn.length == 0){
                    alert("请选择需要删除的市场活动");
                }else if (confirm("是否确认删除！")){
                    //获取所有以选中按钮的value，拼成数据
                    var param = "";
                    $.each($checkedBtn,function (i,e) {
                        param += "id=" + e.value;
                        if (i<($checkedBtn.length - 1)){
                            param += "&";
                        }
                    });
                //    发情ajax请求
                    $.ajax({
                        url:"workbench/activity/delete.do",
                        datatype:"json",
                        data:param,
                        success:function (data) {

                            if (data.success){
                                //删除成功，刷新市场活动列表，我们应该回到第一页，维持展现的条数
                                pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            }else{
                                alert("删除失败");
                            }
                        }

                    });
                }


            });
        //    为修改按钮打开市场活动模态
            $("#editBtn").click(function () {
                //判断选择的活动项目数量
                var $checkedBtn = $("input[name=check]:checked");
                if ($checkedBtn.length == 0){
                    alert("请选择需要修改的市场活动");
                }else if ($checkedBtn.length > 1){
                    alert("只能选择一条活动进行修改");
                }else {

                    //    为修改模态获取信息
                    $.ajax({
                        url:"workbench/activity/getUserListAndActivity.do",
                        datatype:"json",
                        data:{
                            "id":$checkedBtn.val()
                        },
                        success:function (data) {

                        //    为用户列表添加选项
                            var html = "";
                            $.each(data.userList,function (i,e) {
                                html += "<option value='" + e.id + "'> "+e.name + "</option>";
                            });
                            $("#edit-marketActivityOwner").html(html);

                        //    设置默认选项为原信息的所有者
                            $("#edit-marketActivityOwner").val(data.activity.owner);

                        //    为市场活动添加信息

                            $("#edit-id").val(data.activity.id);
                            $("#edit-marketActivityName").val(data.activity.name);
                            $("#edit-startTime").val(data.activity.startDate);
                            $("#edit-endTime").val(data.activity.endDate);
                            $("#edit-cost").val(data.activity.cost);
                            $("#edit-describe").val(data.activity.description);

                            //数据添加完成，展开模态
                            $("#editActivityModal").modal("show");

                        }

                    });
                }
            });


            //    执行修改请求
            $("#updateBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/update.do",
                    type:"post",
                    datatype:"json",
                    data:{
                        "id":$.trim($("#edit-id").val()),
                        "owner":$.trim($("#edit-marketActivityOwner").val()),
                        "name":$.trim($("#edit-marketActivityName").val()),
                        "startDate":$.trim($("#edit-startTime").val()),
                        "endDate":$.trim($("#edit-endTime").val()),
                        "cost":$.trim($("#edit-cost").val()),
                        "description":$.trim($("#edit-describe").val())
                    },
                    success:function (data) {

                        if (data.success){
                            //    更新市场活动
                            //每次打开修改模态窗口都是新的数据，所以不用清空
                            // //    关闭模态窗口并清空模态的信息
                            // $("#addActivityForm")[0].reset();

                            //更新市场活动,我们应该在当前页，并且维持展现的数据条数
                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                            //关闭模态
                            $("#editActivityModal").modal("hide");

                        }else {
                            alert(data.msg)
                        }
                    }
                })
            });


        });





        //查询市场活动的回调函数
            function pageList(pageNo,pageSize) {
                //将全选按钮取消
                $("#checkAll").prop("checked",false);

                //将隐藏域的数据保存到搜索框，防止只填了数据未点击查询就根据数据查信息，使得每次点击分页控件用的还是之前搜索框里的数据
                $("#query-name").val($.trim($("#hidden-name").val()));
                $("#query-owner").val($.trim($("#hidden-owner").val()));
                $("#query-startDate").val($.trim($("#hidden-startDate").val()));
                $("#query-endDate").val($.trim($("#hidden-endDate").val()));

                $.ajax({
                    url:"workbench/activity/pageList.do",
                    datatype:"get",
                    data: {
                        "pageNo":pageNo,
                        "pageSize":pageSize,
                        "name":$.trim($("#query-name").val()),
                        "owner":$.trim($("#query-owner").val()),
                        "startDate":$.trim($("#query-startDate").val()),
                        "endDate":$.trim($("#query-endDate").val())
                    },
                    success:function (data) {
                        //拼接表单内容
                        var html = "";
                        $.each(data.dataList,function (i,e) {
                            html += '<tr class="active">';
                            html += '<td><input type="checkbox" name="check" value="'+ e.id +'"/></td>';
                            html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' +e.id + '\';">' + e.name + '</a></td>';
                            html += '<td>' + e.owner + '</td>';
                            html += '<td>' + e.startDate + '</td>';
                            html += '<td>' + e.endDate + '</td>';
                            html += '</tr>';
                        });

                        $("#activityTableBody").html(html);
                        //    总条数的显示
                        $("#activityPage").bs_pagination({
                            currentPage: pageNo, // 页码
                            rowsPerPage: pageSize, // 每页显示的记录条数
                            maxRowsPerPage: 20, // 每页最多显示的记录条数
                            totalPages: data.totalPages, // 总页数
                            totalRows: data.total, // 总记录条数

                            visiblePageLinks: 3, // 显示几个卡片

                            showGoToPage: true,
                            showRowsPerPage: true,
                            showRowsInfo: true,
                            showRowsDefaultInfo: true,
                            //点击分页组件时调用这个回调函数
                            onChangePage : function(event, data){
                                pageList(data.currentPage , data.rowsPerPage);
                            }
                        });
                    }
                });
            }
    </script>
    <title></title>
</head>
<body>
    <input type="hidden" id="hidden-name" />
    <input type="hidden" id="hidden-owner" />
    <input type="hidden" id="hidden-startDate" />
    <input type="hidden" id="hidden-endDate" />

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="addActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startTime">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endTime">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <input type="hidden" id="edit-id"/>

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label" >所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <%--<option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>--%>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>




<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="query-startDate" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="query-endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="checkAll"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityTableBody">
                <%--<tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="activityPage"></div>

        </div>

    </div>

</div>
</body>
</html>