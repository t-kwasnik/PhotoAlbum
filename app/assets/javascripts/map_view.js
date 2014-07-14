function MapWindow( mapCanvas ) {

  this.main = this
  this.name = mapCanvas
  this.mapCanvas = L.mapbox.map( mapCanvas, 'examples.map-i86nkdio', { zoomControl: false }) ;
  this.layers = {};
  this.containers = {};

  this.startUp = function() {
    new L.Control.Zoom({ position: 'bottomleft' }).addTo( this.mapCanvas ) ;
    this.startListeners();
  }

  this.resetMarkerColors = function(){
    for (var i = 0; i < geoJSON.features.length; i++) {
      geoJSON.features[i].properties['marker-color'] = geoJSON.features[i].properties['old-color'] ||
      geoJSON.features[i].properties['marker-color'];
    };
    markers.setGeoJSON(geoJSON);
    $("#mapped_photos_container img").removeClass("collection_photo_active");
  };

  this.disableMap = function() {
    this.mapCanvas.dragging.disable();
    this.mapCanvas.touchZoom.disable();
    this.mapCanvas.doubleClickZoom.disable();
    this.mapCanvas.scrollWheelZoom.disable();
  };

  this.enableMap = function() {
    this.mapCanvas.dragging.enable();
    this.mapCanvas.touchZoom.enable();
    this.mapCanvas.doubleClickZoom.enable();
    this.mapCanvas.scrollWheelZoom.enable();
  };

  this.startListeners = function(){

    var root = this

    $(".disable_map").mousedown( function() {
      root.disableMap();
    });

    $(".disable_map").hover( function() {
      root.disableMap();
    });

   $(".disable_map").dblclick( function() {
      root.disableMap();
    });

    $(".enable_map").hover( function() {
      root.enableMap();
    });

    $(".enable_map").mousedown( function() {
      root.enableMap();
    });

  };
};