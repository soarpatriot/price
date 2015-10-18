

$(function(){
  if($("#areas-index").length > 0) {

       
    var provinceId =  $("#province_id").val();
    var citySelected = $("#city_selected").val();
    var stationSelected = $("#station_selected").val();
    if(provinceId){
       
      var provinceId =  $("#province_id").val();
      if(provinceId){
        fillCities(provinceId);
      }
      fillStations(citySelected);
    }
    $("#province_id").change(function(){
      var provinceId =  $("#province_id").val();
      if(provinceId){
        fillCities(provinceId);
      }else{
        $("#city_id").empty();
        $("#station_id").empty();
      }
    });
    $("#city_id").change(function(){
      var cityId = $(this).val(); 
      if(cityId){
        fillStations(cityId);
      }else{
        $("#station_id").empty();
      }
    });
     
    $("#search-areas").click(function(){
      $("#area-info-form").attr("action","/areas");
      $("#area-info-form").submit();
    })
    
    $("#export-areas").click(function(){
      $("#area-info-form").attr("action","/areas/export");
      $("#area-info-form").submit();
    })

    $("#export-areas-detail").click(function(){
      $("#area-info-form").attr("action","/areas/export_detail");
      $("#area-info-form").submit();
    })
 
    function fillStations(cityId){
      var cityStationsUrl = api.baseUrl + "/stations/city.json?api_key=" + api.appKey
      var stationOptions= "";
      $.get(cityStationsUrl,{city_id:cityId},function(stations){
         stationOptions += '<option value=""></option>'; 
         $.each(stations,function(index,station){
           stationOptions += '<option value="'+station.id+'">'+station.description+'</option>'; 
         });
         $("#station_id").empty();
         $("#station_id").append(stationOptions);
        if(stationSelected){
           $("#station_id").val(stationSelected);
         }
 
      });
    }

    function fillCities(provinceId) {

      var cityUrl = api.baseUrl + "/provinces/" + provinceId + "/cities.json?api_key=" + api.appKey
      var cityOption = "";
      var citySelected = $("#city_selected").val();
      $.get(cityUrl,{id:provinceId},function(cities){
         console.log("cities:"+ cities);
         cityOption += '<option value=""></option>'; 
         $.each(cities,function(index,city){
           cityOption += '<option value="'+city.id+'">'+city.description+'</option>'; 
         });
         $("#city_id").empty();
         $("#city_id").append(cityOption);
         if(citySelected){
           $("#city_id").val(citySelected);
         }
      });
    }; 

    $('#created-date-start').datetimepicker({
      format: 'YYYY-MM-DD HH:mm:ss',
      locale: 'zh-cn'
    });

    $('#created-date-end').datetimepicker({
      format: 'YYYY-MM-DD HH:mm:ss',
      locale: 'zh-cn'
    });
 
  }

});
 
