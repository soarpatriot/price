

$(function(){
  if($("#areas-edit").length > 0  || $("#areas-update").length > 0 ) {

    $("#man_ids").select2({allowClear: true});
    $("#update-expressmen").click(function(){
      $(this).text("更新中,请稍等...");
      $(this).addClass("disabled")
    })
  }    
});
 
