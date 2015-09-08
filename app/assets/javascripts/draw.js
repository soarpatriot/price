


$(function(){

  if($("#cities-map").length > 0) {
    // 百度地图API功能
    var drawOpt = randomFillOptions();
    var map = new BMap.Map('map-container');
    var poi = new BMap.Point(116.307852,40.057031);
    var cityId = $("#city-id").val();
    var cityName = $("#city-name").val();
    var cityStationsUrl = api.baseUrl + "/stations/city.json";  
    var stationsUrl = api.baseUrl + "/stations.json";
    var ploygons = [];
    var overlaycomplete = function(e){

        var ploygon = e.overlay;
        ploygons.push(ploygon);
        var index =  _.indexOf(ploygons,ploygon);
        ploygon.index = index;
        var ployMenu = new BMap.ContextMenu();
        var editItem = new BMap.MenuItem('编辑',editPloygon.bind(ploygon));
        var saveItem = new BMap.MenuItem('保存',setPloygonStation.bind(ploygon));
        var deleteItem = new BMap.MenuItem('删除',deletePloygon.bind(ploygon));
        ployMenu.addItem(editItem);
        ployMenu.addItem(saveItem);
        ployMenu.addItem(deleteItem);
        
        ploygon.addContextMenu(ployMenu);
   
        console.log(index);
    };
    $("#station-modal").on("show.bs.modal",function(e){
      /**
      $.get("http://localhost:9000/v1/stations/nopoints.json",{city_id:cityId},function(data){
        var optionStr = ""
        $.each(data,function(key,station){
          console.log(station); 
          optionStr += "<option value='"+station.id+"'>"+station.description+"</option>"
        });
        $("#station-select").empty();
        $("#station-select").append(optionStr);
      });**/
      console.log("absdf");  
    });

    $("#station-save").click(function(){
      console.log("save...")
      var data = {};
      var index = $("#ploygon-index").val();
      var ploygon = ploygons[index];
      var points = ploygon.getPath();
      var pos  =  convertObjToDataPoints(points)
      var stationName = $("#station-name").val();
      var cityId = $("#city-id").val();
      var dataStr = ""
      if(ploygon.stationId){
        var stationId = ploygon.stationId;
        var stationUpdateUrl = api.baseUrl + "/stations/"+stationId+".json";
        data = {id:stationId,description: stationName, points: pos }
        dataStr = JSON.stringify(data);
        console.log("dataStr2342"+dataStr);
        
        $.ajax({
          type:"put",
          dataType: "json",
          contentType: "application/json",
          url: stationUpdateUrl, 
          headers: {"X-HTTP-Method-Override": "put"}, 
          success: function(station){
            ploygons[index].stationId = station.id
            ploygons[index].stationName = station.description; 
          },
 
          data: dataStr
        }); 
        ploygon.disableEditing();
      }else{
        data = {stationable_id:cityId,stationable_type:"City", description: stationName, points: pos }
        dataStr = JSON.stringify(data);
        console.log("dataStr121"+dataStr);
        $.ajax({
          type:"post",
          dataType: "json",
          contentType: "application/json",
          url: stationsUrl, 
          success: function(station){
            ploygons[index].stationId = station.id
            ploygons[index].stationName = station.description; 
          },
          data: dataStr
        }); 
        ploygon.disableEditing();
      }
      $("#station-modal").modal("hide");
    });

    map.centerAndZoom(cityName, 12);
    map.enableScrollWheelZoom();  
    $.get(cityStationsUrl,{city_id:cityId},function(data){
      $.each(data,function(key,station){
        console.log(station); 
        var arr = convertToPointsOjeArray(station.points);
        var ploygon = new BMap.Polygon(arr,drawOpt());
       
       //.setLabel(label);
        ploygon.stationId = station.id;
        ploygon.stationName = station.description; 
        var ployMenu = new BMap.ContextMenu();
        var editItem = new BMap.MenuItem('编辑',editPloygon.bind(ploygon));
        var saveItem = new BMap.MenuItem('保存',setPloygonStation.bind(ploygon));
        var deleteItem = new BMap.MenuItem('删除',deletePloygon.bind(ploygon));
 
        ployMenu.addItem(editItem);
        ployMenu.addItem(saveItem);
        ployMenu.addItem(deleteItem);
        ploygon.addContextMenu(ployMenu);
        ploygons.push(ploygon);
        var index =  _.indexOf(ploygons,ploygon);
        ploygon.index = index;
       
        map.addOverlay(ploygon);
        var markerPoint = new BMap.Point(station.longitude,station.lantitude);
        var marker = new BMap.Marker(markerPoint);
        var label = new BMap.Label(station.description,{offset:new BMap.Size(-25,28)});
        label.setStyle(labelOptions);
        marker.setLabel(label);
        map.addOverlay(marker);
     
      });
      //new PNotify(notify.successOpt("家在","家在城管"));
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

    //删除站点
    $("#delete-confirmed-btn").click(function(){
      
      var index = $("#ploygon-delete-index").val(); 
      var ploygon = ploygons[index];
      var stationId = ploygon.stationId;
      var data = {id:stationId}
      var dataStr= JSON.stringify(data);
      console.log("data:" + JSON.stringify(data));
      var deleteUrl = api.baseUrl + "/stations/" + stationId + ".json";
      if(stationId){
        var data = {id:stationId}
        var dataStr= JSON.stringify(data);
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
      map.removeOverlay(ploygon);
      $("#delete-confirm-modal").modal("hide");
    });


  } 
});
