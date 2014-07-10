function populateSelectionWindow(container) {
  container.header.append( selectionViewToggle() );
  container.startListeners = selectionListeners;
  setSelectionWindowAll( container );
  container.update();
  return container;
}

function selectionListeners(){
  container = this
  $("#SelectionAllButton").click(function(event) {
    event.preventDefault();
    setSelectionWindowAll(container);
  });

  $("#SelectionSingleButton").click(function(event) {
    event.preventDefault();
    setSelectionWindowDetail(container);
  });

  return true
}

function selectionViewToggle() {
  output = $("<div></div>")

  $("<a>")
    .attr({"id":"SelectionAllButton", "href":"#", "class":"button tiny"})
    .html("All")
    .appendTo( output )

  $("<a>")
    .attr({"id":"SelectionSingleButton", "href":"#", "class":"button tiny"})
    .html("Detail")
    .appendTo( output );

  return output
}

function setSelectionWindowAll(container) {
  container.footer = mapSelectionDropdown(container);
  container.main_body = selectionWindowAllFormat
  return container.update();
}

function selectionWindowAllFormat() {
  var list = $( "<ul>" );
  for (var i = 0; i < this.contents.length; i++) {
    this.contents[i].html()
      .appendTo( $( "<div>" ).addClass("selected_photo_div"))
      .appendTo( $( "<li>" ) )
      .appendTo( list );
  };
  var div = $("<div>").append( $("<span>").html( this.contents.length + " Total" ));
  list.appendTo( div )
  return div;
  };

function setSelectionWindowDetail() {
  container.footer = "";
  container.main_body = selectionWindowDetailFormat
  return container.update();
}

function selectionWindowDetailFormat() {
  var infoList = $( "<ul>" )
  var infoFields = { "description" : "Description", "placename" : "Location" }

  for (var i = 0; i < this.contents.length; i++) {
    var base = $("<div>").addClass("selected_photo_div");
    data = request.getPhoto(this.contents[i].photo_id)
    base.append( $("<span>").html( ( i + 1 )  + " of " + this.contents.length ) );
    base.append( $("<h1>").html( data.name ) );
    base.append( $("<img>").attr("src", data.image.image.med.url ) );
    for (var field in infoFields) {
      base.append( $("<span>").html( infoFields[field] + ": " + data[field] + "<br>") );
    };

    related_maps = []
    for (var ii = 0; ii < data.related_maps.length; ii++) {
      related_maps.push( data.related_maps[ii].name )
    };

    base.append( $("<span>").html( "In Maps: " + related_maps.join(", ") + "<br>") );

    if ( i == this.contents.length - 1 ) {
      result = $( $("<li>").append(base) ).addClass("focusSelectionWindow")
    } else {
      result = $( $("<li>").append(base) ).hide()
    }

    infoList.append( result );
  };

  infoList.append(
    $("<span>").html("Previous")
      .click(function() {
        if($("li.focusSelectionWindow").prev().length > 0)
          { $("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .prev("li").addClass("focusSelectionWindow").show() } })
    );

  infoList.append(
    $("<span>").html("Next")
      .click(function() {
        if($("li.focusSelectionWindow").next().length > 0)
          {$("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .next("li").addClass("focusSelectionWindow").show()} })
    );

  return infoList;
};

function mapSelectionDropdown( container ) {
    base = $( "<div>" )

    $( "label")
        .attr({ "for": "addSelectionToMapDropdown"})
        .html("Add Selection to:")
        .appendTo(base);

    var selectMapDropDown = $("<select />").attr({"id":"addSelectionToMapDropdown", "name":"addSelectionToMapDropdown"});
    var selectMapData = request.getMyMaps();
    for (var i = 0; i < selectMapData.length; i++) {
        $( $("<option>").attr({"name" : selectMapData[i].name, "value" : selectMapData[i].id })).html(selectMapData[i].name).appendTo(selectMapDropDown);
    };

    selectMapDropDown.appendTo( base );

    $("<a>")
      .attr({"id":"addSelectionToMapButton", "href":"#", "class":"button tiny"})
      .html("Add")
      .appendTo(base)
      .click(function (event) {
        event.preventDefault();
        var value = $("#addSelectionToMapDropdown option:selected").val()
        for (var i = 0; i < container.contents.length; i++) {
          if ( request.createMyMapPhoto(value, container.photo_ids()[i]) == false ) { return } ;
        };
        container.clear_photos();
      });
    return base
  };
