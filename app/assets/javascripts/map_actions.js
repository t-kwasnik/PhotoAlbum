function MapWindow(map, markers, geoJSON, containers){
  this.map = map;
  this.markers = markers;
  this.geoJSON = geoJSON;
  this.containers = containers;

  resetMarkerColors = function(){
    for (var i = 0; i < geoJSON.features.length; i++) {
      geoJSON.features[i].properties['marker-color'] = geoJSON.features[i].properties['old-color'] ||
      geoJSON.features[i].properties['marker-color'];
    };
    markers.setGeoJSON(geoJSON);
    $("#mapped_photos_container img").removeClass("collection_photo_active");
  };

  disableMap = function() {
    map.dragging.disable();
    map.touchZoom.disable();
    map.doubleClickZoom.disable();
    map.scrollWheelZoom.disable();
  };

  enableMap = function() {
    map.dragging.enable();
    map.touchZoom.enable();
    map.doubleClickZoom.enable();
    map.scrollWheelZoom.enable();
  };

  this.startListeners = function(){

    $(".disable_map").mousedown(function() {
      disableMap();
    });

    $(".disable_map").hover(function() {
      disableMap();
    });

   $(".disable_map").dblclick(function() {
      disableMap();
    });

    $(".enable_map").hover(function() {
      enableMap();
    });

    $(".enable_map").mousedown(function() {
      enableMap();
    });

  };
};
