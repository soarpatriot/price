// 第一步创建mapv示例
var mapv = new Mapv({
    drawTypeControl: true,
    map: bmap  // 百度地图的map实例
});

var data = data || []; // 取城市的点来做示例展示的点数据



var layer = new Mapv.Layer({
    mapv: mapv, // 对应的mapv实例
    zIndex: 100, // 图层层级
    dataType: 'point', // 数据类型，点类型
    data: data, // 数据
    drawType: 'density', // 展示形式
    drawOptions: densityDrawOptions
});


