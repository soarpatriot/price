
$(function(){
  if( $("#stations-expressmen").length > 0 || $("#stations-selected_man").length > 0 || $("#stations-syn_all").length > 0 ){
    $("#man_ids").select2({ width: '200px' ,language:"zh-CN" ,theme:"bootstrap"}); 
  }
});
