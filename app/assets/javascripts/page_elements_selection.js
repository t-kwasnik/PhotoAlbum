function populateSelectionWindow( container ) {
  container.header =  selectionViewToggle() ;
  container.startListeners = selectionListeners;
  setSelectionWindowDetail( container );
  container.update();
  return container;
}

function selectionListeners(){
  container = this
  $("#SelectionAllButton").click(function(event) {
    event.preventDefault();
    $( "#selected_photos_container dd" ).removeClass("active");
    $("#SelectionAllButton").parent().addClass("active");
    setSelectionWindowAll(container);
  });

  $("#SelectionSingleButton").click(function(event) {
    event.preventDefault();
    $( "#selected_photos_container dd" ).removeClass("active");
    $("#SelectionSingleButton").parent().addClass("active");
    setSelectionWindowDetail(container);
  });

  return true
}

function selectionViewToggle() {
  output = $("<dl class=\"sub-nav\"><dt>Selection: <dt></dl>")

  $("<dd></dd>")
    .html("<a id =\"SelectionAllButton\" href=\"#\">All</a>")
    .appendTo( output )

  $("<dd class=\"active\"></dd>")
    .html("<a id =\"SelectionSingleButton\" href=\"#\">Detail</a>")
    .appendTo( output );

  return output
}

function setSelectionWindowAll( container ) {
  container.footer = mapSelectionDropdown(container);
  container.main_body = selectionWindowAllFormat
  return container.update();
}

function selectionWindowAllFormat() {
  var container = this
  var list = $( "<ul>" );
  for (var i = 0; i < this.contents.length; i++) {
    var image = container.contents[i].html()
    var div = $("<div>").addClass( this.name + "_div")
    list.append( $( "<li>" ).html( div.append( image ) ) )
  };
  var div = $("<div>").append( $("<span>").html( this.contents.length + " Total" ));
  list.appendTo( div )
  return div;
  };

function setSelectionWindowDetail( container ) {
  container.footer = "";
  container.main_body = selectionWindowDetailFormat
  return container.update();
}

function switchToInput( event ) {
  var target = $(event.target);
  var input_form =  $( "<input id=\"" + target.attr("id") + "\"></input>" )
          .attr( {"type":"text"} )
          .addClass("string")
          .val( target.html() )
          .focusout( savePhotoData );
  target.html( input_form );
  target.children().first().focus();
}

function savePhotoData( event ) {
  var target_value = $(event.target).val()
  var target_photo_id = $(event.target).attr("id").split("_")[1];
  var target_photo_attribute = $(event.target).attr("id").split("_")[0]
  var dataPreUpdate = {}
  dataPreUpdate[ target_photo_attribute ] = target_value
  dataUpdate = { photo : dataPreUpdate }
  update = request.updatePhoto( target_photo_id, dataUpdate )
  $( event.target ).parent().html( update[target_photo_attribute] );
}


function selectionWindowDetailFormat() {
  var container = this
  var infoDiv = $( "<div>" )
  var infoList = $( "<ul>" )
  var textFields = { "description" : "Description",  "placename" : "Location" }
  var tagFields = { "people_tags" : "People", "activities_tags" : "Activities", "other_tags" : "Tags", "related_maps" : "In Maps"  }

  if ( this.contents.length != 0 ) {
    for (var i = 0; i < this.contents.length; i++) {
      var base = $("<div>").addClass( this.name + "_div");
      var photo_id = this.contents[i].photo_id
      data = request.getPhoto( photo_id )
      base.append( $("<p>").html( ( i + 1 )  + " of " + this.contents.length ) );
      base.append( $("<div>").append(
        $("<span>")
          .addClass( "photo_detail" )
          .html( data.name)
          .attr("id", "name_" + photo_id )
          .bind('dblclick', switchToInput )
      ));

      base.append( $("<img>").attr("src", data.image.image.med.url ) );

      for (var field in textFields) {
        base.append( $("<div>")
          .html( "<span class=\"photo_detail_title\">" + textFields[field] + ":</span>")
          .append(
            $( "<span>" )
              .addClass( "photo_detail" )
              .html( data[field] )
              .bind('dblclick', switchToInput )
              .attr("id", field + "_" + photo_id ) ));
      };

      for (var tagField in tagFields) {
        var tagBase = $("<div>").html( "<span class=\"photo_detail_title\">" + tagFields[tagField] + ":</span>")

        tagBase.append( $("<div>")
          .html( "Click to Add" )
          .attr("id", tagField + "_" + photo_id)
          .dblclick( function( event ) {
            var elemID = $(event.target).attr("id").split("_")
            var photoID = elemID[2]
            var categoryName = elemID[0]
            $(event.target).html(
              $("<input>").focusout( function( event ){
                createdTag = request.createTag( photoID, { tag: { name: $(event.target).val() , category: categoryName  }} )
                $(event.target).parent().parent().append( $("<div>").html( createdTag.name ) );
                $(event.target).parent().html( "Click to Add" )
              }))
          }));

        for (var ii = 0; ii < data[tagField].length; ii++) {
          tagBase.append( $("<div>").html( data[tagField][ii].name ) )
        }

        base.append( tagBase )
      }

      if ( i == this.active_content ) {
        result = $( $("<li>").append(base) ).addClass("focusSelectionWindow")
      } else {
        result = $( $("<li>").append(base) ).hide()
      }

      infoList.append( result );
    };
  };

  infoDiv.append( infoList )

  infoDiv.append(
    $("<a>").html("Previous")
      .attr({"id":"selectionDetailPrevious", "href":"#", "class":"button tiny"})
      .click(function(event) {
        event.preventDefault();
        if ($("li.focusSelectionWindow").prev().length > 0)
          { $("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .prev("li").addClass("focusSelectionWindow").show() };
        container.active_content--;
      })
    );

  infoDiv.append(
    $("<a>").html("Next")
      .attr({"id":"selectionDetailNext", "href":"#", "class":"button tiny"})
      .click(function(event) {
        event.preventDefault();
        if ($("li.focusSelectionWindow").next().length > 0)
          {$("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .next("li").addClass("focusSelectionWindow").show()};
      container.active_content++;
      })
    );

  return infoDiv;
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
          var myMapPhoto = request.createMyMapPhoto(value, container.photo_ids()[i] );
        };
        container.clear_photos();
      });
    return base
  };
