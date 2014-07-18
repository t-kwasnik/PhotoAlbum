function parseNewPhoto( mapWindow, geoJSON ) {
  if ( geoJSON.type == "Feature" ) {
      mapWindow.layers.markers.insert( geoJSON )
      mapWindow.containers.map.contents.push( new CollectionPhoto( geoJSON.properties.photo_id, geoJSON.properties.image, mapWindow.containers.map.name))
      mapWindow.containers.map.build()
    } else {
      mapWindow.containers.unmap.contents.push( new CollectionPhoto( geoJSON.properties.photo_id, geoJSON.properties.image, mapWindow.containers.unmap.name))
      mapWindow.containers.unmap.build()
    }
  };



function loadPhotosView() {
  // create window to hold contents

  var photosView = new MapWindow('photos_map');

  // grab data
  var photos = request.getPhotos();
  var my_maps = request.getMyMaps()

  // build empty containers for mapped, unmapped and selected

  var mappedPhotoCollection = new Panel("#mapped_photos_container", "Mapped");
  var unmappedPhotoCollection = new Panel("#unmapped_photos_container", "Unmapped");
  var selectedPhotoCollection = new Panel("#selected_photos_container", "Selection");

  photosView.containers = {
    "map" : mappedPhotoCollection,
    "unmap" : unmappedPhotoCollection,
    "select" : populateSelectionWindow( selectedPhotoCollection, my_maps )
  }

  //build markers
  markers = new MapLayer
  photosView.layers["markers"] = markers

  for(var i = 0; i < photos.length; i++ ) {
    parseNewPhoto( photosView, photos[i] )
  }

  //load user maps
  var mapBoxes = new MapBoxGroup("#my_maps_container")

  for(var i=0; i < my_maps.length; i++){
    var map = new MapBox( my_maps[i] );
    mapBoxes.contents.push(map)
  };
  mapBoxes.update()
  photosView.layers.markers.layer.addTo( photosView.mapCanvas )
  if ( markers.geoJSON.features.length > 0 ) { photosView.mapCanvas.fitBounds( photosView.layers.markers.layer.getBounds() ) };

  //load page
  photosView.startUp();

  //load custom page listeners

  $("#selectedPhotosContainer").draggable({ containment: $("body") })

  photosView.layers.markers.layer.on('click', function(e) {
    $("#selectedPhotosContainer").show()
    prop = e.layer.feature.properties
    prop['old-color'] = prop['marker-color'];
    prop['marker-color'] = '#B24926';
    photosView.layers.markers.layer.setGeoJSON( photosView.layers.markers.layer._geojson );

    $( "#Mapped_" + prop['photo_id'] ).addClass('collection_photo_active');

    if ( $.inArray( prop.photo_id, photosView.containers.select.photo_ids()) == -1 ) {
      var new_photo = new CollectionPhoto( prop.photo_id, prop.image, photosView.containers.select.name )
      photosView.containers.select.insertPhoto( new_photo );
    };
  });

  $("#createNewMap").click( function( event ) {
    $( event.target ).html( $( "<input>" )
        .keypress( function ( event ) {
          var value = $( event.target ).val()
          if ( event.keyCode == 13 ) {
            if ( value != "" ) {
              var new_map = ""
              var target = $( event.target )
              new_map = request.createMyMap( {"my_map": { "name": target.val()}} )
              $("#my_maps_container").append( $("<li>").append(
                $("<a>").attr("href", "my_maps/" + new_map.id ).html(
                  $("<div>").addClass("myMapBox").html( new_map.name )
                )
              ))
            target.parent().html("Create New");
            }
          }
        }
      )
      .focusout( function ( event ) {
        $( event.target ).parent().html("Create New");
      } ))
      $( event.target ).children().first().focus()
    })

  $( "#tabs ul li" ).click(function( event ) {
    event.preventDefault();
    tab = $(event.target).attr("class")
    $( "#tabs ul li.active" ).removeClass("active");
    $( "#photoBarTabs ul li.active" ).removeClass("activeTab").hide();
    $( event.target ).parent().addClass("active");
    $( "#" + tab ).parent().addClass("active").show();
  })

  $("#MapNewPhotos" ).click( function(event) {
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
