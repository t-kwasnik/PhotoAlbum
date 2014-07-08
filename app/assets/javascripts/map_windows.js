function MapToolWindow(tag, map_obj, map_name) {
  $("#"+ map_name).append('<div id="'+ tag +'" class="map_tool selection_window">A</div>')
  $(".selection_window").draggable({ containment: "parent" }).resizable();
  $(".selection_window").addClass("disable_map")
};

function PhotoCollection(base_element_tag, header) {
  this.main = this
  this.header = header
  this.footer = ""
  this.photo_ids = []
  this.contents = [];
  this.base = base_element_tag
  this.asList = function (){
    html = $( "<ul>" );
    for (var i = 0; i < this.contents.length; i++) {
      $( $( "<li>" ).append( this.contents[i].html ) ).appendTo(html);
    };
    return html;
  };
  this.update = function (){
    output = $( this.main.base ).html( $( "<h1>" ).html( this.main.header ) );
    this.main.asList().appendTo( output );
    $( this.main.footer ).appendTo( output );
    output
  };
  this.clear_photos = function() {
    this.photo_ids = [];
    this.contents = [];
    this.main.update(this.main)
  };
  this.clear_contents = function() {
    this.photo_ids = [];
    this.contents = [];
    this.main.footer = "";
    this.main.update(this.main)
  };
};

function updateSelectionFooter(select_container) {
    select_container.footer = $( "<div>" )

    $( "label")
        .attr({ "for": "addSelectionToMapDropdown"})
        .html("Add Selection to:")
        .appendTo(select_container.footer);

    var selectMapDropDown = $("<select />").attr({"id":"addSelectionToMapDropdown", "name":"addSelectionToMapDropdown"});
    var selectMapData = request.getMyMaps();
    for (var i = 0; i < selectMapData.length; i++) {
        $( $("<option>").attr({"name" : selectMapData[i].name, "value" : selectMapData[i].id })).html(selectMapData[i].name).appendTo(selectMapDropDown);
    };

    selectMapDropDown.appendTo( select_container.footer );

    $("<a>")
      .attr({"id":"addSelectionToMapButton", "href":"#", "class":"button tiny"})
      .html("Add")
      .appendTo(select_container.footer)
      .click(function (event) {
        event.preventDefault();
        var value = $("#addSelectionToMapDropdown option:selected").val()
        for (var i = 0; i < select_container.contents.length; i++) {
          if ( request.createMyMapPhoto(value, select_container.photo_ids[i]) == false ) { return } ;
        };
        select_container.clear_contents();
      });

    select_container.update();
  };

function CollectionPhoto(photo_id, photo_url) {
  this.photo_id = photo_id;
  this.photo_url = photo_url;
  this.html = $('<img />').attr({ class: 'collection_photo', 'id': this.photo_id, 'src': this.photo_url });
};

function SelectedPhotoDiv(collection_photo) {
  this.html = $( $("<div>").append( collection_photo.html ) ).addClass("selected_photo_div")
};
