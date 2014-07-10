$( document ).ready( function() {

  var myMap = L.mapbox.map('my_map', 'examples.map-i86nkdio', { zoomControl: false })
  new L.Control.Zoom({ position: 'bottomleft' }).addTo(myMap);
  var data = request.getPhotos();

  var geoJSON = { "type" : "FeatureCollection", "features" : [] }

  var mappedPhotoCollection = new PhotoCollection("#mapped_photos_container", "Mapped");
  var unmappedPhotoCollection = new PhotoCollection("#unmapped_photos_container", "Unmapped");
  var selectedPhotoCollection = new PhotoCollection("#selected_photos_container", "Selection");

  var containers = {
      "map" : mappedPhotoCollection,
      "unmap" : unmappedPhotoCollection,
      "select" : populateSelectionWindow( selectedPhotoCollection )
    }

  for (var i = 0; i < data.length; i++) {
    var photo_id = data[i].properties.photo_id
    var photo_url = data[i].properties.image
    if ( data[i].type == "Feature" ) {
      geoJSON.features.push(data[i])
      containers.map.contents.push( new CollectionPhoto(photo_id, photo_url, containers.map.name))
    } else if ( data[i].type == "Unmapped" ) {
      containers.unmap.contents.push( new CollectionPhoto(photo_id, photo_url, containers.unmap.name))
    };
  };
  containers.map.update();
  containers.unmap.update();

  var markers = L.mapbox.featureLayer(geoJSON);
  markers.addTo(myMap);
  myMap.fitBounds(markers.getBounds());

  $( "#showUnplaced" ).click(function() {
    unplaced = MapToolWindow("unplaced", myMap, "my_map")
  });

  markers.on('click', function(e) {
    prop = e.layer.feature.properties
    prop['old-color'] = prop['marker-color'];
    prop['marker-color'] = '#B24926';
    markers.setGeoJSON( geoJSON );

    $( "#photo" + prop['photo_id'] ).addClass('collection_photo_active');

    if ( $.inArray( prop.photo_id, containers.select.photo_ids()) == -1 ) {
      var new_photo = new CollectionPhoto( prop.photo_id, prop.image, containers.select.name )
      containers.select.contents.push( new_photo );
      containers.select.update()
    };
  });

  var mapWindow = new MapWindow(myMap,markers,geoJSON, containers);
  mapWindow.startListeners();
});
