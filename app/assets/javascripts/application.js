// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); });

function MapToolWindow(tag, map_obj, map_name) {

  $("#"+ map_name).append('<div id="'+ tag +'" class="map_tool selection_window">A</div>')
  $(".selection_window").draggable({ containment: "parent" }).resizable();
  $(".selection_window").addClass("disable_map")

};

function PhotoCollection() {
  this.photos = [];
  this.asList = function (){
    html = $( "<ul>" );
    for (var i = 0; i < this.photos.length; i++) {
      this.photos[i].html.appendTo(html);
    };
    return html;
  }
}

function CollectionPhoto(photo_id, photo_url) {
  this.photo_id = photo_id;
  this.photo_url = photo_url;
  this.html = $("<li>").append(
                  $('<img />').attr({ class: 'collection_photo', 'id': this.photo_id, 'src': this.photo_url })
                );
};

function MapWindow(map, markers, geoJSON){
  this.map = map;
  this.markers = markers;
  this.geoJSON = geoJSON;

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
      resetMarkerColors();
      prop = e.layer.feature.properties
      prop['old-color'] = prop['marker-color'];
      prop['marker-color'] = '#B24926';
      markers.setGeoJSON(geoJSON);
      $( "#photo" + prop['photo_id'] ).addClass('collection_photo_active');
    });

    map.on('click',resetMarkerColors);

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


$( window ).load( function() {

  var myMap = L.mapbox.map('my_map', 'examples.map-i86nkdio', { zoomControl: false })
  new L.Control.Zoom({ position: 'bottomleft' }).addTo(myMap);
  var data = {}

  $.ajax({
      url: '/photos.json',
      dataType: 'json',
      async: false,
      success: function(d) {
            data = d;
      }
  });

  var geoJSON = { "type" : "FeatureCollection", "features" : [] }
  var mappedPhotoCollection = new PhotoCollection();
  var unmappedPhotoCollection = new PhotoCollection();

  for (var i = 0; i < data.length; i++) {
    var photo_id = "photo" + data[i].properties.photo_id
    var photo_url = data[i].properties.image
    if ( data[i].type == "Feature" ) {
      geoJSON.features.push(data[i])
      mappedPhotoCollection.photos.push( new CollectionPhoto(photo_id, photo_url))
    } else if ( data[i].type == "Unmapped" ) {
      unmappedPhotoCollection.photos.push( new CollectionPhoto(photo_id, photo_url))
    };
  };
  var markers = L.mapbox.featureLayer(geoJSON);
  markers.addTo(myMap);
  myMap.fitBounds(markers.getBounds());
  var mapWindow = new MapWindow(myMap,markers,geoJSON);

  $( "#mapped_photos_container" ).append( mappedPhotoCollection.asList() );
  $( "#unmapped_photos_container" ).append( unmappedPhotoCollection.asList() );

  $( "#showUnplaced" ).click(function() {
    unplaced = MapToolWindow("unplaced", myMap, "my_map")
  });

  mapWindow.startListeners();
});






