function parseNewPhoto( mapWindow, geoJSON ) {
  if ( geoJSON.type == "Feature" ) {
      mapWindow.layers.markers.insert( geoJSON )
      mapWindow.containers.map.contents.push( new CollectionPhoto( geoJSON.properties.photo_id, geoJSON.properties.image, mapWindow.containers.map.name))
      mapWindow.containers.map.update()
    } else {
      mapWindow.containers.unmap.contents.push( new CollectionPhoto( geoJSON.properties.photo_id, geoJSON.properties.image, mapWindow.containers.unmap.name))
      mapWindow.containers.unmap.update()
    }
  };

function loadPhotosView() {

  // create window to hold contents
  var photosView = new MapWindow('photos_map');

  // build empty containers for mapped, unmapped and selected
  var mappedPhotoCollection = new Container("#mapped_photos_container", "Mapped");
  var unmappedPhotoCollection = new Container("#unmapped_photos_container", "Unmapped");
  var selectedPhotoCollection = new Container("#selected_photos_container", "Selection");

  photosView.containers = {
      "map" : mappedPhotoCollection,
      "unmap" : unmappedPhotoCollection,
      "select" : populateSelectionWindow( selectedPhotoCollection )
    }

  // specify initial features to map
  var data = request.getPhotos();

  markers = new MapLayer
  photosView.layers["markers"] = markers

  for(var i = 0; i < data.length; i++ ) {
    parseNewPhoto( photosView, data[i] )
  }

  photosView.layers.markers.layer.addTo( photosView.mapCanvas )
  if ( markers.geoJSON.features.length > 0 ) { photosView.mapCanvas.fitBounds( photosView.layers.markers.layer.getBounds() ) };

  //load map
  photosView.startUp();

  $( "#showUnplaced" ).click(function() {
    unplaced = MapToolWindow( "unplaced", photosView.name )
  });

  photosView.layers.markers.layer.on('click', function(e) {
    prop = e.layer.feature.properties
    prop['old-color'] = prop['marker-color'];
    prop['marker-color'] = '#B24926';
    photosView.layers.markers.layer.setGeoJSON( photosView.layers.markers.layer._geojson );

    $( "#Mapped_" + prop['photo_id'] ).addClass('collection_photo_active');

    if ( $.inArray( prop.photo_id, photosView.containers.select.photo_ids()) == -1 ) {
      var new_photo = new CollectionPhoto( prop.photo_id, prop.image, photosView.containers.select.name )
      photosView.containers.select.contents.push( new_photo );
      photosView.containers.select.update()
    };
  });

  $( "#MapNewPhotos" ).click( function(event) {
      event.preventDefault();
      var files = document.getElementById('photosToMap').files;
      var formData = new FormData();
      for (var i = 0; i < files.length; i++) {
        var formData = new FormData();
        var file = files[i];
        formData.append('photo[image]', file, file.name);
        request.createPhoto(formData, photosView, ["map", "unmap"]);
      };
    });
}
