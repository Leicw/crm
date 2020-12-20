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
        <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
        <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

        <script type="text/javascript">

            $(function(){
                pageList(1,2);

                //    按钮的全选处理
                $("#checkAll").click(function () {
                    $("input[name=check]").prop("checked",this.checked);
                });
                //传统的方式无法为动态生成的按钮绑定事件，只能用on
                $("#transactionBody").on("click",$("input[name=check]"),function () {
                    $("#checkAll").prop("checked",$("input[name=check]").length == $("input[name=check]:checked").length)
                });

                $("#queryBtn").click(function () {

                    //将查询的数据保存到隐藏域，防止只填了数据未点击查询就根据数据查信息
                    $("#hidden-owner").val($.trim($("#query-owner").val()));
                    $("#hidden-name").val($.trim($("#query-name").val()));
                    $("#hidden-customerName").val($.trim($("#query-customerName").val()));
                    $("#hidden-stage").val($.trim($("#query-stage").val()));
                    $("#hidden-type").val($.trim($("#query-type").val()));
                    $("#hidden-source").val($.trim($("#query-source").val()));
                    $("#hidden-contactsName").val($.trim($("#query-contactsName").val()));
                    //查询后应该调到第一页，维持条数
                    pageList(1,$("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));

                });

            });

            //查询市场活动的回调函数
            function pageList(pageNo,pageSize) {
                //将全选按钮取消
                $("#checkAll").prop("checked",false);
                //将隐藏域的数据保存到搜索框，防止只填了数据未点击查询就根据数据查信息，使得每次点击分页控件用的还是之前搜索框里的数据
                $("#query-owner").val($.trim($("#hidden-owner").val()));
                $("#query-name").val($.trim($("#hidden-name").val()));
                $("#query-customerName").val($.trim($("#hidden-customerName").val()));
                $("#query-stage").val($.trim($("#hidden-stage").val()));
                $("#query-type").val($.trim($("#hidden-type").val()));
                $("#query-source").val($.trim($("#hidden-source").val()));
                $("#query-contactsName").val($.trim($("#hidden-contactsName").val()));


                $.ajax({
                    url:"workbench/transaction/pageList.do",
                    datatype:"get",
                    data: {
                        "pageNo":pageNo,
                        "pageSize":pageSize,
                        "owner":$.trim($("#query-owner").val()),
                        "name":$.trim($("#query-name").val()),
                        "customerName":$.trim($("#query-customerName").val()),
                        "stage":$.trim($("#query-stage").val()),
                        "type":$.trim($("#query-type").val()),
                        "source":$.trim($("#query-source").val()),
                        "contactsName":$.trim($("#query-contactsName").val()),

                    },
                    success:function (data) {
                        //拼接表单内容
                        var html = "";
                        $.each(data.dataList,function (i,e) {
                            /*html += '<tr class="active">';
                            html += '<td><input type="checkbox" name="check" value="'+ e.id +'"/></td>';
                            html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id=' +e.id + '\';">' + e.name + '</a></td>';
                            html += '<td>' + e.owner + '</td>';
                            html += '<td>' + e.startDate + '</td>';
                            html += '<td>' + e.endDate + '</td>';
                            html += '</tr>';*/

                            html += '<tr class="active">';
                            html += '<td><input type="checkbox" name="check" value="'+ e.id +'"/></td>';
                            html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+ e.id +'\';">'+ e.name +'</a></td>';
                            html += '<td>'+ e.customerId +'</td>';
                            html += '<td>'+ e.stage +'</td>';
                            html += '<td>'+ e.type +'</td>';
                            html += '<td>'+ e.owner +'</td>';
                            html += '<td>'+ e.source +'</td>';
                            html += '<td>'+ e.contactsId +'</td>';
                            html += '</tr>';
                        });

                        $("#transactionBody").html(html);
                        //    总条数的显示
                        $("#transactionPage").bs_pagination({
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
    </head>
    <body>
    <input type="hidden" id="hidden-owner" />
    <input type="hidden" id="hidden-type" />
    <input type="hidden" id="hidden-name" />
    <input type="hidden" id="hidden-customerName" />
    <input type="hidden" id="hidden-stage" />
    <input type="hidden" id="hidden-source" />
    <input type="hidden" id="hidden-contactsName" />


    <div>
        <div style="position: relative; left: 10px; top: -10px;">
            <div class="page-header">
                <h3>交易列表</h3>
            </div>
        </div>
    </div>

    <div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

        <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

            <div class="btn-toolbar" role="toolbar" style="height: 80px;">
                <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                    <div class="form-group">
                        <div class="input-group">
                            <div class="input-group-addon">所有者</div>
                            <input class="form-control" type="text" id="query-owner">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-group">
                            <div class="input-group-addon">名称</div>
                            <input class="form-control" type="text" id="query-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-group">
                            <div class="input-group-addon">客户名称</div>
                            <input class="form-control" type="text" id="query-customerName">
                        </div>
                    </div>

                    <br>

                    <div class="form-group">
                        <div class="input-group">
                            <div class="input-group-addon">阶段</div>
                            <select class="form-control" id="query-stage">
                                <option></option>
                                <c:forEach var="sta" items="${stageList}">
                                    <option value="${sta.value}">${sta.text}</option>
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
                        <div class="input-group">
                            <div class="input-group-addon">类型</div>
                            <select class="form-control" id="query-type">
                                <option></option>
                                <c:forEach var="tl" items="${transactionTypeList}">
                                    <option value="${tl.value}">${tl.text}</option>
                                </c:forEach>
                                <%--<option></option>
                                <option>已有业务</option>
                                <option>新业务</option>--%>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="input-group">
                            <div class="input-group-addon">来源</div>
                            <select class="form-control" id="query-source">
                                <option></option>
                                <c:forEach var="sl" items="${sourceList}">
                                    <option value="${sl.value}">${sl.text}</option>
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
                    </div>

                    <div class="form-group">
                        <div class="input-group">
                            <div class="input-group-addon">联系人名称</div>
                            <input class="form-control" type="text" id="query-contactsName">
                        </div>
                    </div>

                    <button type="button" class="btn btn-default" id="queryBtn">查询</button>

                </form>
            </div>
            <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
                <div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                    <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                    <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
                </div>


            </div>
            <div style="position: relative;top: 10px;">
                <table class="table table-hover">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="checkAll"/></td>
                        <td>名称</td>
                        <td>客户名称</td>
                        <td>阶段</td>
                        <td>类型</td>
                        <td>所有者</td>
                        <td>来源</td>
                        <td>联系人名称</td>
                    </tr>
                    </thead>
                    <tbody id="transactionBody">
                    <%--<tr>
                        <td><input type="checkbox" /></td>
                        <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                        <td>动力节点</td>
                        <td>谈判/复审</td>
                        <td>新业务</td>
                        <td>zhangsan</td>
                        <td>广告</td>
                        <td>李四</td>
                    </tr>
                    <tr class="active">
                        <td><input type="checkbox" /></td>
                        <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
                        <td>动力节点</td>
                        <td>谈判/复审</td>
                        <td>新业务</td>
                        <td>zhangsan</td>
                        <td>广告</td>
                        <td>李四</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>

            <div style="height: 50px; position: relative;top: 20px;">
                <div id="transactionPage"></div>
            </div>

        </div>

    </div>
    </body>
</html>