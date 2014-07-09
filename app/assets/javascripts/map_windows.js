function MapToolWindow(tag, map_obj, map_name) {
  $("#"+ map_name).append('<div id="'+ tag +'" class="map_tool selection_window">A</div>')
  $(".selection_window").draggable({ containment: "parent" }).resizable();
  $(".selection_window").addClass("disable_map")
};

function PhotoCollection(base_element_tag, header) {
  this.main = this;
  this.base = base_element_tag;
  this.header = $( "<h1></h1>" ).html( header );
  this.footer = "";
  this.contents = [];
  this.startListeners = function(){};
  this.photo_ids = function(){
      array = [];
      for (var i = 0; i < this.contents.length; i++) {
        array.push( this.contents[i].photo_id );
      };
      return array
  };
  this.asList = function (){
    html = $( "<ul>" );
    for (var i = 0; i < this.contents.length; i++) {
      $( $( "<li>" ).append( this.contents[i].html() ) ).appendTo(html);
    };
    return html;
  };
  this.main_body = this.asList;
  this.update = function (){
    output = $( this.main.base ).html(" ");
    $( this.main.header ).appendTo( output );
    this.main_body().appendTo( output );
    $( this.main.footer ).appendTo( output );
    this.main.startListeners();
    return output
  };
  this.clear_photos = function() {
    this.contents = [];
    return this.main.update(this.main);

  };
  this.clear_footer = function() {
    this.main.footer = "";
    return this.main.update( this.main );
  };
};


function CollectionPhoto( photo_id, photo_url, header ) {
  this.header = header
  this.photo_id = photo_id;
  this.photo_url = photo_url;
  this.info_fields = {"description" : "Description", "placename" : "Location" }
  this.attr = function() {
    return request.getPhoto( this.photo_id );
  };
  this.image = function() {
    return $('<img />').attr({ class: 'collection_photo', 'id': this.header + "_" + this.photo_id, 'src': this.photo_url })
  };
  this.html = this.image;
  this.in_div = function() {
    return $( $("<div>").append( this.image() ) )
  };
  this.in_info_div = function() {
    data = this.attr();
    base = $("<div>");
    base.append( $("<h1>").html( data.name ) );
    this.photo_url = data.image.image.med.url
    base.append( this.image() );
    for (var field in this.info_fields) {
      base.append( $("<span>").html( this.info_fields[field] + ": " + data[field] ) );
    };
    return base;
  };

};
