<%@ page import="java.util.List" %>
<%@ page import="com.lcw.crm.settings.domain.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <% String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() +  request.getContextPath() ;%>
    <base href=<%=basePath%>/>
    <% List<User> userList = (List<User>) request.getAttribute("userList"); %>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){
            $("#remark").focus(function(){
                if(cancelAndSaveBtnDefault){
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height","130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function(){
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height","90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function(){
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function(){
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function(){
                $(this).children("span").css("color","red");
            });

            $(".myHref").mouseout(function(){
                $(this).children("span").css("color","#E6E6E6");
            });

        //    页面刷新完毕，我们展现备注
            showRemarkList();
            //恢复备注的动画
            $("#remarkBody").on("mouseover",".remarkDiv",function(){
                $(this).children("div").children("div").show();
            });
            $("#remarkBody").on("mouseout",".remarkDiv",function(){
                $(this).children("div").children("div").hide();
            })
        });

        //    展现市场活动信息列表，因为有多个按钮都要刷新展现，所以用异步请求，而不是写死
        function showRemarkList(){
        //    请求参数我们使用EL表达式，即可获取当前页面的市场活动id
            $.ajax({
                url:"workbench/activity/getRemarkList.do",
                datatype:"json",
                data:{
                    "activityId":"${activity.id}"
                },
                success:function (data) {
                //    我们需要拼接字符串
                    var html = "";
                   $.each(data,function (i,e) {
                   html += '<div class="remarkDiv" style="height: 60px;" id="'+ e.id +'">';
                   html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                   html += '<div style="position: relative; top: -40px; left: 40px;" >';
                   html += '<h5 id="noteContent'+ e.id +'">'+ e.noteContent +'</h5>';
                   html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"id="update'+ e.id +'"> '+ (e.editFlag == 0?e.createTime:e.editTime) +' 由'+ (e.editFlag == 0?e.createBy:e.editBy) +'</small>';
                   html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                   html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;" onclick="editRemark(\''+ e.id +'\')"></span></a>';
                   html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                   html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;" onclick="deleteRemark(\''+ e.id +'\')"></span></a>';
                   html += '</div>';
                   html += '</div>';
                   html += '</div>';
                    });
                //    使用before()添加标签，不能使用html，否则其他标签消失
                    $("#remarkDiv").before(html);
                }
            })
        }

         //删除市场活动备注的回调
         function deleteRemark(id){
            //提醒用户是否删除
             if(confirm("是否确认删除这条备注")){
                 $.ajax({
                     url:"workbench/activity/deleteRemark.do",
                     datatype:"json",
                     data:{
                         "id":id
                     },
                     success:function (data) {
                        if (data.success){
                        //    删除成功我们需要刷新备注列表，但是因为showRemarkList（）用的是before添加标签，所以我不能用
                            $("#" + id).remove();
                        }else{
                            alert(data.msg)
                        }
                     }
                 })

             }
         }

        //编辑备注的回调
        function editRemark(id){
            //将模态的备注信息改为要修改的备注
            $("#noteContent").val($("#noteContent"+id).text());
            //将备注的id放在隐藏域，以便更新操作时用
            $("#remarkId").val(id);
            //展现模态
            $("#editRemarkModal").modal("show");
        }



        $(function () {

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

            //对编辑市场活动按钮的点击时绑定事件
            $("#editBtn").click(function () {
                //将默认用户选项设置为当前用户
                $("#edit-marketActivityOwner").val("${user.id}");
                //打开模态
                $("#editActivityModal").modal("show");
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
                            //关闭模态
                            $("#editActivityModal").modal("hide");

                            window.location.href="workbench/activity/detail.do?id=${activity.id}";

                        }else {
                            alert(data.msg)
                        }
                    }
                })
            });

            //  为删除操作绑定事件
            $("#deleteBtn").click(function () {
                //    发情ajax请求
                $.ajax({
                    url:"workbench/activity/delete.do",
                    datatype:"json",
                    data:{
                        "id":"${activity.id}"
                    },
                    success:function (data) {

                        if (data.success){
                        //    删除成功回到市场活动列表
                            window.location.href="workbench/activity/index.jsp";
                        }else{
                            alert("删除失败");
                        }
                    }
                });
            });

            //添加市场活动备注
            $("#saveRemarkBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/saveRemark.do",
                    datatype:"json",
                    type:"post",
                    data:{
                        "activityId":"${activity.id}",
                        "noteContent":$.trim($("#remark").val())
                    },
                    success:function (data) {

                        if (data.success){
                            //    添加成功，我清空文本域的信息
                            $("#remark").val("");
                            //    拼接一个备注
                            var html = "";
                            html += '<div class="remarkDiv" style="height: 60px;" id="'+ data.remark.id +'">';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="noteContent'+ data.remark.id +'">'+ data.remark.noteContent +'</h5>';
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="update'+ data.remark.id +'"> '+ data.remark.createTime +' 由'+ data.remark.createBy +'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;" onclick="editRemark(\''+ data.remark.id +'\')"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;" onclick="deleteRemark(\''+ data.remark.id +'\')"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';

                            //    我们需要添加在顶部
                            $("#hideRemark").after(html);
                        }else{
                            alert(data.msg);
                        }
                    }
                })
            });
        //    更新市场活动
            $("#updateRemarkBtn").click(function () {
                var id = $("#remarkId").val();
                $.ajax({
                    url:"workbench/activity/updateRemark.do",
                    datatype:"json",
                    type:"post",
                    data:{
                        "id":id,
                        "noteContent":$.trim($("#noteContent").val())
                    },
                    success:function (data) {
                        if(data.success) {

                            //    修改成功我们更新备注和修改时间修改人
                            $("#update"+id).text(data.remark.editTime + " 由" +data.remark.editBy);
                            $("#noteContent"+id).text(data.remark.noteContent);
                        //    关闭模态
                            $("#editRemarkModal").modal("hide");
                        }else {
                            alert(data.msg);
                        }
                    }
                })

            })
        });

    </script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="edit-id" value="${activity.id}">
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

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner" >
<%--                                拼接用户名--%>
                                <% for(User user:userList){%>
                                <option value="<%=user.getId()%>"><%=user.getName()%></option>
                                <%}%>

                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="${activity.name}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startTime" value="${activity.startDate}">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endTime" value=${activity.endDate}>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="${activity.cost}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">${activity.description}</textarea>
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

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>市场活动-${activity.name} <small>${activity.createTime} ~ ${activity.createTime}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
    <div class="page-header">
        <h4>备注</h4>
    </div>
<%--   这个隐藏域用户在此后面添加市场活动，而不最后添加，更美观--%>
    <input type="hidden" id="hideRemark"/>
    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>哎呦！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <!-- 备注2 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>呵呵！</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
            </p>
        </form>
    </div>
</div>
<div style="height: 200px;"></div>
</body>
</html>
