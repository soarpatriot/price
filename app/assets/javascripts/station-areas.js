

$(function(){
  if($("#station-map").length > 0) {
    // 百度地图API功能
    var map = new BMap.Map('map-container');
    var poi = new BMap.Point(116.307852,40.057031);
    var stationId = $("#station-id").val();
    var ploygons = [];
    var stationUrl = "http://localhost:9000/v1/stations/"+stationId+".json"
    var areaUrl = "http://localhost:9000/v1/stations/"+stationId+"/areas.json"

 
    var overlays = [];
    var overlaycomplete = function(e){
        var ploygon = e.overlay;
        var ployMenu = new BMap.ContextMenu();
        var editItem = new BMap.MenuItem('编辑',editPloygon.bind(ploygon));
        var saveItem = new BMap.MenuItem('保存',setPloygonArea.bind(ploygon));
        var deleteItem = new BMap.MenuItem('删除',deletePloygonArea.bind(ploygon));
        //var editAreaItem = new BMap.MenuItem('编辑所属站点',setPloygonArea.bind(ploygon));
        ployMenu.addItem(editItem);
        ployMenu.addItem(saveItem);
        ployMenu.addItem(deleteItem);
        // ployMenu.addItem(editAreaItem);
        
        ploygon.addContextMenu(ployMenu);
       
        // overlays.push(e.overlay);
    };
    $("#commission-modal").on("show.bs.modal",function(e){
      $.get("http://localhost:9000/v1/commissions.json",function(data){
        var optionStr = ""
        $.each(data,function(key,commission){
          console.log(commission); 
          optionStr += "<option value='"+commission.id+"'>"+commission.name+"</option>"
        });
        $("#commission-select").empty();
        $("#commission-select").append(optionStr);
      });
      console.log("absdf");  
    });

    $("#commission-save").click(function(){
      console.log("save...")
      var pointsStr = $("#unsaved-points").val();
      var areaId = $("#area-id").val();
      var commessionId = $("#commission-select").val();
      var label = "abc";
      var dataStr = "";
      console.log("dataStr"+dataStr);
      var areaSaveUrl = "http://localhost:9000/v1/areas.json" 
      var updateAreaUrl = "";
      //$.post(areaSaveUrl)
      console.log("area id:"+areaId); 
      if(areaId){
        console.log("if area id:"+areaId); 
        updateAreaUrl = "http://localhost:9000/v1/areas/"+areaId+".json"
        dataStr = '{"label":"'+label+'","station_id":'+stationId+',"area_id":'+areaId+',"points":'+pointsStr+'}';
        $.ajax({
          type:"put",
          dataType: "json",
          contentType: "application/json",
          url: updateAreaUrl, 
          headers: {"X-HTTP-Method-Override": "put"}, 
          crossDomain: true,
          data: dataStr
        }); 
      
      }else{
        dataStr = '{"label":"'+label+'","station_id":'+stationId+',"points":'+pointsStr+'}';
        $.ajax({
          type:"post",
          dataType: "json",
          contentType: "application/json",
          url: areaSaveUrl, 
          headers: {"Access-Control-Allow-Origin": "*"}, 
          crossDomain: true,
          data: dataStr
        }); 
      
      } 
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
        ploygon.areaId = area.id; 
         
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
