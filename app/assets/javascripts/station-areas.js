

$(function(){
  if($("#station-map").length > 0) {
    // 百度地图API功能
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
       
    };
    $("#commission-modal").on("show.bs.modal",function(e){
      var commisionsUrl = api.baseUrl + "/commissions.json"
      $.get(commisionsUrl,function(data){
        var optionStr = ""
        $.each(data,function(key,commission){
          console.log(commission); 
          optionStr += "<option value='"+commission.id+"'>"+commission.name+"</option>"
        });
        $("#commission-select").empty();
        $("#commission-select").append(optionStr);
        var index =  $("#ploygon-index").val();
        var ploygon = ploygons[index];
        if(ploygon.commissionId){
          $("#commission-select").val(ploygon.commissionId);
        }
      });
      console.log("absdf");  
    });

    $("#commission-save").click(function(){
      console.log("save...")
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
      console.log("dataStr"+dataStr);
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
            ploygons[index].commissionId = area.commission_id; 
            ploygons[index].commissionName = area.commission_name; 
            ploygons[index].commissionPrice = area.commission_price; 
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
          },
 
          data: dataStr
        }); 
      
      } 
      ploygon.disableEditing();
      $("#commission-modal").modal("hide");

    });

    map.centerAndZoom(poi, 15);
    map.enableScrollWheelZoom();  
    $.get(stationUrl,{id:stationId},function(station){
      console.log(station.points); 
      var arr = convertToPointsOjeArray(station.points);
      var ploygon = new BMap.Polygon(arr,styleOptions);
      
      var markerPoint = new BMap.Point(station.longitude,station.lantitude);
      var marker = new BMap.Marker(markerPoint);
      var label = new BMap.Label(station.description,{offset:new BMap.Size(20,-10)});
      marker.setLabel(label);
      map.addOverlay(marker);
      ploygon.stationId = station.id;
      map.addOverlay(ploygon);

    });   
    $.get(areaUrl,{station_id:stationId},function(data){
      $.each(data,function(key,area){
        console.log(area); 
        var arr = convertToPointsOjeArray(area.points);
        var ploygon = new BMap.Polygon(arr,styleOptions);
        ploygons.push(ploygon);
        var index =  _.indexOf(ploygons,ploygon);
        ploygon.index = index;
        ploygon.areaId = area.id; 
        ploygon.commissionId = area.commission_id; 
        ploygon.commissionName = area.commission_name; 
        ploygon.commissionPrice = area.commission_price; 
         
        var ployMenu = new BMap.ContextMenu();
        var editItem = new BMap.MenuItem('编辑',editPloygon.bind(ploygon));
        var saveItem = new BMap.MenuItem('保存',setPloygonArea.bind(ploygon));
        var deleteItem = new BMap.MenuItem('删除',deletePloygonArea.bind(ploygon));
        //var editAreaItem = new BMap.MenuItem('编辑所属站点',setPloygonArea.bind(ploygon));
        map.addOverlay(ploygon);
        ployMenu.addItem(editItem);
        ployMenu.addItem(saveItem);
        ployMenu.addItem(deleteItem);
        ploygon.addContextMenu(ployMenu);

      });
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

  }       
});
