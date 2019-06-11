$(function(){
	//绑定切换事件
    $(".TYPE_SELECT").live("change",function(){
        var type = $(this).val();
        var columnCommentJson = {};
        columnCommentJson.type=type;
        var idx = $(this).attr("idx");
        initDefaultAndSetValueBycolumnCommentJson(idx,columnCommentJson);
    });
    //全选事件
    $("#cb_0").change(function(){
        var checked = $(this).prop("checked");
        $(".checkbox_gp0").prop("checked",checked);
    })
})
