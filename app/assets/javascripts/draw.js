


$(function(){
  if($("#city-map").length > 0) {
    // 百度地图API功能
    var map = new BMap.Map('map-container');
    var poi = new BMap.Point(116.307852,40.057031);
    var cityId = $("#city-id").val();
  
    var overlays = [];
    var overlaycomplete = function(e){
        var overlay = e.overlay;
        overlay.addEventListener("click",function(){
          var points = overlay.getPath();
          var pos  =  convertObjToDataPoints(points)
          $("#unsaved-points").val(JSON.stringify(pos));
          $("#station-modal").modal("show");

          console.log("aa"); 
        });
        
        /** 
        $.map(points,function(p,i){
          console.log(i);
          console.log("lat:"+p.lat+",lng:"+p.lng);
        })**/
        
        //console.log(e.overlay.Q);
        overlays.push(e.overlay);
    };
    $("#station-modal").on("show.bs.modal",function(e){
      $.get("http://localhost:9000/v1/stations/nopoints.json",{city_id:cityId},function(data){
        var optionStr = ""
        $.each(data,function(key,station){
          console.log(station); 
          optionStr += "<option value='"+station.id+"'>"+station.description+"</option>"
        });
        $("#station-select").empty();
        $("#station-select").append(optionStr);
      });
      console.log("absdf");  
    });

    $("#station-save").click(function(){
      console.log("save...")
      var pointsStr = $("#unsaved-points").val();
      var stationId = $("#station-select").val();
      var dataStr = '{"id":'+stationId+',"points":'+pointsStr+'}';
      console.log("dataStr"+dataStr);
      $.ajax({
        type:"put",
        dataType: "json",
        contentType: "application/json",
        url: "http://localhost:9000/v1/stations/"+stationId+".json", 
        headers: {"X-HTTP-Method-Override": "put"}, 
        data: dataStr
      }); 
    });

    map.centerAndZoom(poi, 15);
    map.enableScrollWheelZoom();  
    var ploygons = [];
    $.get("http://localhost:9000/v1/stations/city.json",{city_id:cityId},function(data){
      console.log(data); 
      $.each(data,function(key,station){
        console.log(station); 
        var arr = convertToPointsOjeArray(station.points);
        var ploygon = new BMap.Polygon(arr,styleOptions);
        
        var markerPoint = new BMap.Point(station.longitude,station.lantitude);
        var marker = new BMap.Marker(markerPoint);
        var label = new BMap.Label(station.description,{offset:new BMap.Size(20,-10)});
        marker.setLabel(label);
        map.addOverlay(marker);
        //.setLabel(label);
        ploygon.stationId = station.id;
        ploygon.addEventListener("dblclick",function(){
          ploygon.enableEditing()
          //console.log("edit");
        });
        ploygon.addEventListener("lineupdate",function(type,target){
          
          //console.log("type:"+type);
          //console.log("type:"+ploygon.stationId);
          //console.log("points:"+points);
           
          //console.log("data:"+JSON.stringify(data));

        });
        ploygons.push(ploygon);
        map.addOverlay(ploygon);
      });

      $("#save-btn").click(function(){
         var i=0;
         var data;
         var points;
         var pos;
         var stationId;
         var dataStr;
         for(i=0; i<ploygons.length;i++){
            points = ploygons[i].getPath();
            pos = convertObjToDataPoints(points);

            stationId = ploygons[i].stationId;
            data = {id:stationId,points:pos}
            dataStr= JSON.stringify(data);
            console.log("data:" + JSON.stringify(data));
            $.ajax({
              type:"put",
              dataType: "json",
              contentType: "application/json",
              url: "http://localhost:9000/v1/stations/"+stationId+".json", 
              headers: {"X-HTTP-Method-Override": "put"}, 
              data: dataStr
            }); 
         }
      });

    });   

    //实例化鼠标绘制工具
    var drawingManager = new BMapLib.DrawingManager(map, {
        isOpen: false, //是否开启绘制模式
        enableDrawingTool: true, //是否显示工具栏
        drawingToolOptions: {
            anchor: BMAP_ANCHOR_TOP_RIGHT, //位置
            offset: new BMap.Size(5, 5), //偏离值
        },
        circleOptions: styleOptions, //圆的样式
        polylineOptions: styleOptions, //线的样式
        polygonOptions: drawOptions, //多边形的样式
        rectangleOptions: styleOptions //矩形的样式
    });  
    //添加鼠标绘制工具监听事件，用于获取绘制结果
    drawingManager.addEventListener('overlaycomplete', overlaycomplete);

 }       
});
