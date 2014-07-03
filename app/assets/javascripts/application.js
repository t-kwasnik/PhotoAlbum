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

  $("#"+ map_name).prepend('<div id="'+ tag +'" class="MapTool MapToolWindow">A</div>')

  $("#" + tag ).draggable({ containment: "parent" }).resizable();

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
  };
};


$(window).load(function() {



  var myMap = L.mapbox.map('my_map', 'examples.map-i86nkdio')
  var geoJSON = {}

  $.ajax({
      url: '/photos.json',
      dataType: 'json',
      async: false,
      success: function(data) {
            geoJSON = data;
      }
  });

 $(".MapTool").mousedown(function() {
    myMap.dragging.disable();
    myMap.touchZoom.disable();
    myMap.doubleClickZoom.disable();
    myMap.scrollWheelZoom.disable();
  });

  $(".MapTool").hover(function() {
    myMap.dragging.disable();
    myMap.touchZoom.disable();
    myMap.doubleClickZoom.disable();
    myMap.scrollWheelZoom.disable();
  });

  $("#my_map").mouseup(function() {
    myMap.dragging.enable();
    myMap.touchZoom.enable();
    myMap.doubleClickZoom.enable();
    myMap.scrollWheelZoom.enable();
  });

  var markers = L.mapbox.featureLayer(geoJSON);
  markers.addTo(myMap);
  myMap.fitBounds(markers.getBounds());
  var mapWindow = new MapWindow(myMap,markers,geoJSON);


  var mappedPhotoCollection = new PhotoCollection();
  for (var i = 0; i < geoJSON.features.length; i++) {
    var photo_id = "photo" + geoJSON.features[i].properties.photo_id
    var photo_url = geoJSON.features[i].properties.image
    mappedPhotoCollection.photos.push( new CollectionPhoto(photo_id, photo_url ))
  };

  $( "#mapped_photos_container" ).append( mappedPhotoCollection.asList() );

  $( "#showUnplaced" ).click(function() {
    unplaced = MapToolWindow("unplaced", myMap, "my_map")
  });

  mapWindow.startListeners();
});






