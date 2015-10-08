
$(function(){
  if($("#stations-area").length > 0) {
    // 百度地图API功能
    var drawOpt = randomFillOptions();
    var map = new BMap.Map('map-container');
    var poi = new BMap.Point(116.307852,40.057031);
    var stationId = $("#station-id").val();
    var ploygons = [];
    var stationUrl = api.baseUrl+ "/stations/"+stationId+".json"
    var areaUrl = api.baseUrl + "/stations/"+stationId+"/areas.json"

 
    var ploygons = [];
    var overlaycomplete = function(e){
        var ploygon = e.overlay;
        ploygons.push(ploygon);
        var index =  _.indexOf(ploygons,ploygon);
        ploygon.index = index;
 
        var ployMenu = new BMap.ContextMenu();
        var editItem = new BMap.MenuItem('编辑',editPloygon.bind(ploygon));
        var saveItem = new BMap.MenuItem('保存',setPloygonArea.bind(ploygon));
        var deleteItem = new BMap.MenuItem('删除',deletePloygonArea.bind(ploygon));
        //var editAreaItem = new BMap.MenuItem('编辑所属站点',setPloygonArea.bind(ploygon));
        ployMenu.addItem(editItem);
        ployMenu.addItem(saveItem);
        ployMenu.addItem(deleteItem);
        ploygon.addContextMenu(ployMenu);
        centerPoint =  ploygon.getBounds().getCenter();       
    };


    //density 
    // 第一步创建mapv示例
    map.centerAndZoom(new BMap.Point(105.403119, 38.028658), 5);
    var mapv = new Mapv({
        drawTypeControl: true,
        map: map  // 百度地图的map实例
    });

    var data = []; // 取城市的点来做示例展示的点数据
    var layer = {};
    var layer = new Mapv.Layer({
        mapv: mapv, // 对应的mapv实例
        zIndex: -10, // 图层层级
        dataType: 'point', // 数据类型，点类型
        data: data, // 数据
        drawType: 'density', // 展示形式
        drawOptions: densityDrawOptions
    });
    layer.setMapv(null);
    $("#commission-modal").on("show.bs.modal",function(e){
      var commisionsUrl = api.baseUrl + "/commissions.json"
      $.get(commisionsUrl,function(data){
        var optionStr = ""
        $.each(data,function(key,commission){
          optionStr += "<option value='"+commission.id+"'>"+commission.name+"("+commission.price+")</option>"
        });
        $("#commission-select").empty();
        $("#commission-select").append(optionStr);
        var index =  $("#ploygon-index").val();
        var ploygon = ploygons[index];
        if(ploygon.commissionId){
          $("#commission-select").val(ploygon.commissionId);
        }
      });
    });

    $("#commission-save").click(function(){
      var data = {};
      var stationId = $("#station-id").val();
      var index = $("#ploygon-index").val();
      var ploygon = ploygons[index];
      var points = ploygon.getPath();
      var pos  =  convertObjToDataPoints(points)
 
      var areaId = ploygon.areaId;
      var commissionId = $("#commission-select").val();
      var label = "abc";
      var dataStr = "";
      var areaSaveUrl = api.baseUrl + "/areas.json" 
      var updateAreaUrl = "";
      //$.post(areaSaveUrl)
      console.log("area id:"+areaId); 
      if(areaId){
        console.log("if area id:"+areaId); 
        updateAreaUrl = api.baseUrl + "/areas/"+areaId+".json"
        data = {label:label, station_id:stationId, commission_id: commissionId,area_id:areaId,points:pos}
        dataStr = JSON.stringify(data);
        $.ajax({
          type:"put",
          dataType: "json",
          contentType: "application/json",
          url: updateAreaUrl, 
          headers: {"X-HTTP-Method-Override": "put"}, 
          crossDomain: true,
          success: function(area){
            var areaMian = BMapLib.GeoUtils.getPolygonArea(ploygons[index]);
            var areaMianDesc = (areaMian/1000000).toFixed(2) + "(平方公里)";
            // var areaMianDesc = areaMian.toFixed(2) + "平方米";
            var labelValue = area.commission_name + "("+area.commission_price+")<br/>"+ areaMianDesc;
            ploygons[index].commissionId = area.commission_id; 
            ploygons[index].commissionName = area.commission_name; 
            ploygons[index].commissionPrice = area.commission_price; 


            if(ploygons[index].centerLabel){
              ploygons[index].centerLabel.setContent(labelValue);
            }
          },
          data: dataStr
        }); 
      
      }else{
        data = {label:label, station_id:stationId,commission_id:commissionId, points:pos}
        dataStr = JSON.stringify(data);
        $.ajax({
          type:"post",
          dataType: "json",
          contentType: "application/json",
          url: areaSaveUrl, 
          headers: {"Access-Control-Allow-Origin": "*"}, 
          crossDomain: true,
          success: function(area){
            
            ploygons[index].areaId = area.id; 
            ploygons[index].commissionId = area.commission_id; 
            ploygons[index].commissionName = area.commission_name; 
            ploygons[index].commissionPrice = area.commission_price; 

            var areaMian = BMapLib.GeoUtils.getPolygonArea(ploygons[index]);
            var areaMianDesc = (areaMian/1000000).toFixed(2) + "(平方公里)";
            //  var areaMianDesc = areaMian.toFixed(2) + "平方米";
            //var areaMianDesc = area.toFixed(2) + "平方米";


            var centerPoint = ploygons[index].getBounds().getCenter();
            var opts = {position: centerPoint, offset: new BMap.Size(-15,-5)}
            var labelValue = area.commission_name + "("+area.commission_price+")<br/>"+ areaMianDesc;
            var label = new BMap.Label(labelValue,opts);
            ploygons[index].centerLabel = label;
            map.addOverlay(label); 
          },
 
          data: dataStr
        }); 
      
      } 
      ploygon.disableEditing();
      $("#commission-modal").modal("hide");

    });

   $.get(stationUrl,{id:stationId},function(station){
      var arr = convertToPointsOjeArray(station.points);
      var ploygon = new BMap.Polygon(arr,styleOptions);
      var centerLan;
      var centerLng;
      
      if(station.longitude && station.lantitude){
        centerLan = station.lantitude;
        centerLng = station.longitude;
      }else if(station.points.length > 0){
        var centerPoint = ploygon.getBounds().getCenter();
        centerLan = centerPoint.lat;
        centerLng = centerPoint.lng;
      }
         


      var markerPoint = new BMap.Point(centerLng,centerLan);
      var marker = new BMap.Marker(markerPoint);
      map.addOverlay(marker);
      var label = new BMap.Label(station.description,{offset:new BMap.Size(-25,25)});
      label.setStyle(labelOptions);
      marker.setLabel(label);

      map.centerAndZoom(markerPoint, 13);
      map.enableScrollWheelZoom();  
      
      ploygon.stationId = station.id;
      map.addOverlay(ploygon);

      //add base overlay finished, then add areas
      $.get(areaUrl,{station_id:stationId},function(data){
        $.each(data,function(key,area){
          console.log(area); 
          var arr = convertToPointsOjeArray(area.points);
          var ploygon = new BMap.Polygon(arr,drawOpt());
          var areaMian = BMapLib.GeoUtils.getPolygonArea(ploygon);
          var areaMianDesc = (areaMian/1000000).toFixed(2) + "(平方公里)";
          //var areaMianDesc = area.toFixed(2) + "平方米";

          var centerPoint = ploygon.getBounds().getCenter();
          var opts = {position: centerPoint, offset: new BMap.Size(-15,-5)}
          var labelValue = area.commission_name + "("+area.commission_price+")<br/>"+areaMianDesc;
          var label = new BMap.Label(labelValue,opts);
          //label.setStyle(labelOptions);
          map.addOverlay(label);

          ploygons.push(ploygon);
          var index =  _.indexOf(ploygons,ploygon);
          ploygon.index = index;
          ploygon.areaId = area.id; 
          ploygon.commissionId = area.commission_id; 
          ploygon.commissionName = area.commission_name; 
          ploygon.commissionPrice = area.commission_price; 
          ploygon.centerLabel = label;           

          var ployMenu = new BMap.ContextMenu();
          var editItem = new BMap.MenuItem('编辑',editPloygon.bind(ploygon));
          var saveItem = new BMap.MenuItem('保存',setPloygonArea.bind(ploygon));
          var deleteItem = new BMap.MenuItem('删除',deletePloygonArea.bind(ploygon));
          //var editAreaItem = new BMap.MenuItem('编辑所属站点',setPloygonArea.bind(ploygon));
          ployMenu.addItem(editItem);
          ployMenu.addItem(saveItem);
          ployMenu.addItem(deleteItem);
          ploygon.addContextMenu(ployMenu);
          
          map.addOverlay(ploygon);

        });
      });

 
    });   
    
    $("#delete-confirmed-btn").click(function(){
      
      var index = $("#ploygon-delete-index").val(); 
      var ploygon = ploygons[index];
      var areaId = ploygon.areaId;

      if(areaId){
        var deleteUrl = api.baseUrl + "/areas/" + areaId + ".json";
        var dataStr = '{"id":'+areaId+'}'
        $.ajax({
          type:"delete",
          dataType: "json",
          contentType: "application/json",
          url: deleteUrl, 
          headers: {"X-HTTP-Method-Override": "delete"}, 
          data: dataStr
        }); 
      }
      var map = ploygon.getMap();
      if(ploygon.centerLabel){
        map.removeOverlay(ploygon.centerLabel);
      }
      map.removeOverlay(ploygon);
       
      $("#delete-confirm-modal").modal("hide");
    });
    //实例化鼠标绘制工具
    var drawingManager = new BMapLib.DrawingManager(map, {
        isOpen: false, //是否开启绘制模式
        enableDrawingTool: true, //是否显示工具栏
        drawingToolOptions: {
            anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
            offset: new BMap.Size(5, 5), //偏离值
            drawingModes: [BMAP_DRAWING_POLYGON]
        },
        polygonOptions: drawOptions //多边形的样式
    });  
    //添加鼠标绘制工具监听事件，用于获取绘制结果
    drawingManager.addEventListener('overlaycomplete', overlaycomplete);
    
    var jqXhr; 
    $("#draw-test-btn").click(function(){
      $("#choose-density-modal").modal("show"); 
    });
    $("#cancel-density-btn").click(function(){
      if(jqXhr){
        jqXhr.abort();
      }
      $("#choose-density-modal").modal("hide"); 
    });
    $("#choose-density-btn").click(function(){
      var startDateValue = $("#start-date-text").val();
      console.log("start data value:"+ startDateValue)
      var stationName = $("#station-name").val();
      var cityName = $("#city-name").val();
      var endDateValue = $("#end-date-text").val();
      var displayChecked = $("#display-density-checkbox").is(':checked');
      if(displayChecked){
        layer.setMapv(mapv);
        if(startDateValue){
          $("#choose-density-btn").prop( "disabled", true );
          $("#choose-density-btn").toggleClass("disabled");
          $("#choose-density-btn i").toggleClass("hide");
   
          //var dataUrlBase = "http://10.3.23.247:8081/kettle/trans/ordersLntAndLat";
          var dataUrlBase = "http://javapi-commission.wuliusys.com/kettle/trans/ordersLntAndLat";
          var city_name = cityName;
          var express_company_name= stationName;
          var start_date = startDateValue;
          var end_date  = endDateValue;
          var dataUrl = dataUrlBase + "?cityName=" + city_name + 
            "&expressCompanyName="+  express_company_name + "&startDate=" + start_date
          console.log(dataUrl);
           
          // dataUrl  = "http://10.3.23.247:8080/kettle/runTrans";
          jqXhr = $.ajax({
            url: dataUrl 
          }).done(function(result){
               var optionStr = ""
               var jsonResult = JSON.parse(result)
               if(result.error){
                 console.log("订单密度出错！"); 
               }else{
               
                 layer.setData(jsonResult.data); 
               }
               console.log(JSON.stringify(result)); 
            }).fail(function(jqXHR,status){
              console.log(status); 
            }).always(function(){
              $("#choose-density-btn" ).prop( "disabled", false );
              if($("#choose-density-btn").hasClass("disabled")){
                $("#choose-density-btn").removeClass("disabled");
              }
              $("#choose-density-btn i").toggleClass("hide");
              $("#choose-density-modal").modal("hide"); 
            });
          
        }else{
        } 
      }else{
        layer.setMapv(null);
        //  layer.setData([]); 
      }
      console.log("dss:"+displayChecked);
    });

    $('#start-date').datetimepicker({
      format: 'YYYY-MM',
      locale: 'zh-cn'
    });
    $('#end-date').datetimepicker({
      format: 'YYYY-MM-DD',
      locale: 'zh-cn'
    });
    /**
    $("#start-date").on("dp.change", function (e) {
        $('#end-date').data("DateTimePicker").minDate(e.date);
    });
    $("#end-date").on("dp.change", function (e) {
        $('#start-date').data("DateTimePicker").maxDate(e.date);
    });**/


  }
});
