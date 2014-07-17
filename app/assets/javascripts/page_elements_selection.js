function populateSelectionWindow( container ) {
  container.header =  selectionViewToggle() ;
  container.startListeners = selectionListeners;
  container.main_body = selectionMainBody ;
  container.update();
  return container;
}

function selectionListeners(){
  container = this
  $("#SelectionAllButton").click( switchSelectionView ) ;
  $("#SelectionSingleButton").click( switchSelectionView );
  return true
}

function switchSelectionView( event ){
    event.preventDefault();
    $( event.target ).parent().parent().children("li.active").removeClass("active");
    $("#selectionViews li:hidden").show()
    $("#selectionViews li.active").hide();
    $("#selectionViews li:visible").addClass("active");
    $("#selectionViews li:hidden").removeClass("active");
    $( event.target ).parent().addClass("active");
  }

function selectionViewToggle() {
  output = $( "<ul>" ).addClass( "nav nav-pills" ).append(
    $("<li>").addClass("active").html("<a id =\"SelectionSingleButton\" href=\"#\">Detail</a>")
    ).append(
    $("<li>").html( ("<a id =\"SelectionAllButton\" href=\"#\">All</a>" )))
  return output
}

function selectionMainBody( ) {
  var container = this
  var main_body = $("<ul>").attr("id", "selectionViews").append(
    $("<li>").attr("id","SelectionAllList").append( selectionWindowAllFormat( container ) ).hide()
    ).append(
    $("<li>").attr("id","SelectionSingleList").addClass("active").append( selectionWindowDetailFormat( container ) )
    )
  return main_body
}

function selectionWindowAllFormat( container ) {
  var list = $( "<ul class = \"selectionAllList disable_map\">" );
  for (var i = 0; i < container.contents.length; i++) {
    var image = container.contents[i].html()
    var div = $("<div>").addClass( container.name + "_div selectionAllDiv")
    list.append( $( "<li>" ).html( div.append( image ) ) )
  };
  var div = $("<div>").append( $("<span>").html( container.contents.length + " Total" ));
  list.appendTo( div )

  mapSelectionDropdown( container, container.photo_ids() ).appendTo( div )

  return div;
  };

function switchToInput( event ) {
  var target = $(event.target);
  var input_form =  $( "<input id=\"" + target.attr("id") + "\"></input>" )
          .attr( {"type":"text"} )
          .addClass("string")
          .val( target.html() )
          .keypress( savePhotoData );
  target.html( input_form );
  target.children().first().focus();
}

function savePhotoData( event ) {
  if ( event.keyCode == 13 ) {
    var target_value = $(event.target).val()
    var target_photo_id = $(event.target).attr("id").split("_")[1];
    var target_photo_attribute = $(event.target).attr("id").split("_")[0]
    var dataPreUpdate = {}
    dataPreUpdate[ target_photo_attribute ] = target_value
    dataUpdate = { photo : dataPreUpdate }
    update = request.updatePhoto( target_photo_id, dataUpdate )
    $( event.target ).parent().html( update[target_photo_attribute] );
  }
}

function deleteTagButton( id ) {
  return $("<a href=\"#\" id=\"" + id + "\">&nbsp;x</a>")
    .click( function ( event ) {
      event.preventDefault()
      request.deletePhotoTag( $(event.target).attr("id") )
      $(event.target).parent().remove();
    } )
}

function photoDetailSpan( field, value, photo_id ) {
  return $("<span>")
          .addClass( "photo_detail" )
          .html( value)
          .attr("id", field + "_" + photo_id )
          .bind('dblclick', switchToInput )
}

function selectionWindowDetailFormat( container ) {
  var infoDiv = $( "<div>" )
  var infoList = $( "<ul>" )
  var textFields = { "description" : "Description",  "placename" : "Location" }
  var tagFields = { "people_tags" : "Person", "activities_tags" : "Activity", "other_tags" : "Tag" }

  if ( container.contents.length != 0 ) {
    for (var i = 0; i < container.contents.length; i++) {
      var base = $("<div>").addClass( container.name + "_div").addClass("container-fluid");
      var row1 = $( "<div>" ).addClass("row-fluid")
      var row1contents = $("<div>").addClass("col-xs-12")
      var row2 = $( "<div>" ).addClass("row-fluid")
      var row2image = $("<div>").addClass("col-xs-4")
      var row2info = $("<div>").addClass("col-xs-6")
      var photo_id = container.contents[i].photo_id
      data = request.getPhoto( photo_id )

      //page count
      row1contents.append( $("<span>").html( ( i + 1 )  + " of " + container.contents.length ) );

      //title
      row1contents.append( $("<div>").append( $("<h3>").append( photoDetailSpan( "name", data.name , photo_id ))) );

      //image
      row2image.append( $("<img>").attr("src", data.image.image.med.url ) );

      //description and location
      for (var field in textFields) {
        row2info.append( $("<div>")
          .html( "<span class=\"photo_detail_title\">" + textFields[field] + ":</span>")
          .append( photoDetailSpan( field, data[field], photo_id )))
      };


      //related maps
      related_maps = []
      for ( var x = 0; x < data["related_maps"].length; x++ ){
        related_maps.push( data["related_maps"][x].name )
      }

      row2info.append( $("<div>").append(
        $( "<span class=\"photo_detail_title\"></span>" ).html( "In Maps" ))
        .append( $("<span>").html( related_maps.join(",") ) ))

      //Add to map dropdown
      row2info.append( mapSelectionDropdown( container, [photo_id] ) );

      //tag fields
      var tagBase = $("<div>").html( "<span class=\"photo_detail_title\" id=\"selectionTags_" + photo_id + "\" >Tags:</span>" )
      var tagFooter = $("<div>")

      for (var tagField in tagFields) {

        for (var ii = 0; ii < data[tagField].length; ii++) {
          tagBase.append( $("<div>")
              .html( data[tagField][ii].name )
              .addClass( "SelectionTag round label " + tagFields[tagField] + "Tag" )
              .append( deleteTagButton( data[tagField][ii].id )))
        }

        tagFooter.append( $("<div>")
          .html( tagFields[tagField] +" + " )
          .addClass( "SelectionTag round label " + tagFields[tagField] + "Tag" )
          .attr("id", tagField + "_" + photo_id)
          .click( function( event ) {
            var elemID = $(event.target).attr("id").split("_")
            var photoID = elemID[2]
            var categoryName = elemID[0]
            var originalHTML = $(event.target).html()
            $(event.target).html(
              $("<input>").keypress( function( event ){
                if ( event.keyCode == 13 ) {
                  if ( $(event.target).val() != "" ) {
                    createdTag = request.createTag( { tag: { name: $(event.target).val() , category: categoryName  }} )
                    createdPhotoTag = request.createPhotoTag( { photo_tag: { photo_id: photoID, tag_id: createdTag.id }}  )

                    $("#selectionTags_" + photoID).append(
                      $("<div>").html( createdTag.name )
                        .addClass( $(event.target).parent().attr("class") )
                        .append( deleteTagButton( createdPhotoTag.id ) )
                      );
                    }
                    $( event.target ).parent().html( originalHTML )
                  }})
            )

            $(event.target).children().first().focus()
          }
        ));
      }

      row2info.append( tagBase )
      row2info.append( tagFooter )
      debugger
      base.append( row1.append( row1contents ) ).append( row2.append(row2image).append(row2info) )

      if ( i == container.active_content ) {
        result = $( $("<li>").append(base) ).addClass("focusSelectionWindow")
      } else {
        result = $( $("<li>").append(base) ).hide()
      }

      infoList.append( result );
    };
  };

  infoDiv.append( infoList )

  infoDiv.append(

    $("<ul>").addClass("pager").append(

    $("<li>").append( $("<a href=\"#\"></a>").html("Previous")
      .click(function(event) {
        event.preventDefault();
        if ($("li.focusSelectionWindow").prev().length > 0)
          { $("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .prev("li").addClass("focusSelectionWindow").show() };
        container.active_content--;
      })
    )).append(

    $("<li>").append( $("<a href=\"#\"></a>").html("Next")
      .click(function(event) {
        event.preventDefault();
        if ($("li.focusSelectionWindow").next().length > 0)
          { $("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .next("li").addClass("focusSelectionWindow").show() };
        container.active_content++;
      })
    )))

  return infoDiv;
};

function mapSelectionDropdown( container, selected_photos_ids ) {

    base = $( "<div>" )

    base.append( $( "label" )
        .attr({ "for": "addSelectionToMapDropdown"})
        .html("Add to:")
        .appendTo(base) )

    var selectMapDropDown = $("<select />").attr({"id":"addSelectionToMapDropdown", "name":"addSelectionToMapDropdown"});
    var selectMapData = request.getMyMaps();
    for (var i = 0; i < selectMapData.length; i++) {
        $( $("<option>").attr({"name" : selectMapData[i].name, "value" : selectMapData[i].id })).html(selectMapData[i].name).appendTo(selectMapDropDown);
    };

    selectMapDropDown.appendTo( base );

    $("<button>")
      .attr({"id":"addSelectionToMapButton", "class":"round label"})
      .html("Add")
      .appendTo(base)
      .click(function (event) {
        debugger
        event.preventDefault();
        var value = $("#addSelectionToMapDropdown option:selected").val()
        for (var i = 0; i < selected_photos_ids.length; i++) {
          var myMapPhoto = request.createMyMapPhoto(value, selected_photos_ids[i] );
        };
      });
    return base
  };
