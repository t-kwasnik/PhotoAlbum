function MapWindow(map, markers, geoJSON, containers){
  this.map = map;
  this.markers = markers;
  this.geoJSON = geoJSON;
  this.containers = containers

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
    markers.on('click', function(e) {
      prop = e.layer.feature.properties
      prop['old-color'] = prop['marker-color'];
      prop['marker-color'] = '#B24926';
      markers.setGeoJSON( geoJSON );

      $( "#photo" + prop['photo_id'] ).addClass('collection_photo_active');
      alert(containers.select.photo_ids);
      if ( $.inArray( prop.photo_id, containers.select.photo_ids) == -1 ) {
        containers.select.photo_ids.push( prop.photo_id );
        containers.select.contents.push(
          new SelectedPhotoDiv(
            new CollectionPhoto(prop.photo_id, prop.image)
          ));
        updateSelectionFooter(containers.select)
      };

    });

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
