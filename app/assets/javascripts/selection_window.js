function populateSelectionWindow(container) {
  selectionViewToggle().appendTo( container.header )
  container.startListeners = selectionListeners;
  setSelectionWindowAll(container);
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
    setSelectionWindowSingle(container);
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
  for( var i = 0; i < container.contents.length; i++ ) {
    container.contents[i].html = container.contents[i].in_div;
  };
  return container.update();
}

function setSelectionWindowSingle(container) {
  container.footer = "";
  for( var i = 0; i < container.contents.length; i++ ) {
    container.contents[i].html = container.contents[i].in_info_div;
  };
  return container.update();
}

function mapSelectionDropdown(container) {
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
