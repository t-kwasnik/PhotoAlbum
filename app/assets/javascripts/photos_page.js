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
      "select" : selectedPhotoCollection
    }

  for (var i = 0; i < data.length; i++) {
    var photo_id = "photo" + data[i].properties.photo_id
    var photo_url = data[i].properties.image
    if ( data[i].type == "Feature" ) {
      geoJSON.features.push(data[i])
      mappedPhotoCollection.photo_ids.push( photo_id )
      mappedPhotoCollection.contents.push( new CollectionPhoto(photo_id, photo_url))
    } else if ( data[i].type == "Unmapped" ) {
      unmappedPhotoCollection.contents.push( new CollectionPhoto(photo_id, photo_url))
      unmappedPhotoCollection.photo_ids.push( photo_id )
    };
  };

  mappedPhotoCollection.update();
  unmappedPhotoCollection.update();

  var markers = L.mapbox.featureLayer(geoJSON);
  markers.addTo(myMap);
  myMap.fitBounds(markers.getBounds());
  var mapWindow = new MapWindow(myMap,markers,geoJSON, containers);

  $( "#showUnplaced" ).click(function() {
    unplaced = MapToolWindow("unplaced", myMap, "my_map")
  });

  mapWindow.startListeners();
});
