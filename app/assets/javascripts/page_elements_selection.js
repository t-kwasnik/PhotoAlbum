function populateSelectionWindow( container, related_maps ) {
  container.build = buildSelectionWindow ;
  container.insertPhoto = insertNewSelectionPhoto;
  container.related_maps = related_maps
  return container;
}

function switchSelectionView( event ){
    event.preventDefault();
    $( event.target ).parent().parent().children("li.active").removeClass("active");
    $("div.selectionList:hidden").show()
    $("div.selectionList.active").hide();
    $("div.selectionList:visible").addClass("active");
    $("div.selectionList:hidden").removeClass("active");
    $( event.target ).parent().addClass("active");
  }

function selectionViewToggle() {
  output = $( "<ul>" ).addClass( "nav nav-pills" ).append(
    $("<li>")
      .addClass("active")
      .html("<a id =\"SelectionSingleButton\" href=\"#\">Detail</a>")
      .click( switchSelectionView )
    ).append(
    $("<li>")
      .html( ("<a id =\"SelectionAllButton\" href=\"#\">All</a>" ))
      .click( switchSelectionView ) )
  return output
}

function buildSelectionWindow() {
  var container = this
  $("#selectedPhotosContainer")
    .append( $( "<div>" ).addClass("row-fluid")
      .append( $( "<div>" ).addClass("col-xs-11").html( selectionViewToggle() ) )
      .append( $( "<div>" ).addClass("col-xs-1").html(
        $("<i class=\"fa fa-power-off\"></i>").click( function(){
          $("#selectedPhotosContainer").hide() } ) )))
    .append( selectionWindowAllFormat( container ) )
    .append( selectionWindowDetailFormat( container ) )
}

function selectionWindowAllFormat( container ) {
  var allFormat = $("<div>").addClass("selectionList disable_map").hide()
  var selectionDetailAllList = $( "<ul>" ).addClass("selectionAllList")

  allFormat.append( selectionDetailAllList )
  allFormat.append(
    $( "<div>" ).addClass("row-fluid")
      .append( $("<div>").addClass("col-xs-12").html( mapSelectionDropdown( container, container.photo_ids() ) )
    )
  );
  return allFormat
};

function selectionWindowDetailFormat( container ) {
  var infoDiv = $( "<div>" ).addClass(" active selectionList disable_map")
  var infoList = $( "<ul>" ).addClass("selectionDetailList")

  infoDiv.append( infoList )
  infoDiv.append(

    $("<ul>").addClass("pager").append(

    $("<li>").append( $("<a href=\"#\"></a>").html("Next")
      .click(function(event) {
        event.preventDefault();
        if ($("li.focusSelectionWindow").next().length > 0)
          { $("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .next("li").addClass("focusSelectionWindow").show() };
        container.active_content++;
      })
    )).append(

    $("<li>").append( $("<a href=\"#\"></a>").html("Previous")
      .click(function(event) {
        event.preventDefault();
        if ($("li.focusSelectionWindow").prev().length > 0)
          { $("li.focusSelectionWindow").removeClass("focusSelectionWindow").hide()
              .prev("li").addClass("focusSelectionWindow").show() };
        container.active_content--;
      })
    )))


  return infoDiv;
};

function insertNewSelectionPhoto( collectionPhoto ) {
  this.contents.push( collectionPhoto )
  $("ul.selectionAllList").append( $("<li>").append(
    $("<div>").addClass( "selectionAllDiv").html( collectionPhoto.html().addClass("selectionImage") ).addClass("col-xs-3")
  ))

  var detailContent = buildSelectionDetailDiv( this, collectionPhoto )

  if ( this.contents.length > 1 ){
    detailContent.hide()
  } else {
    detailContent.addClass("focusSelectionWindow")
  }

  $("ul.selectionDetailList").append( detailContent )
}

function buildSelectionDetailDiv( container, collectionPhoto ) {
  var textFields = { "description" : "Description",  "placename" : "Location" }
  var tagFields = { "people_tags" : "Person", "activities_tags" : "Activity", "other_tags" : "Tag" }
  var base = $("<li>").addClass( container.name + "DetailContent");
  var row1 = $( "<div>" ).addClass("row-fluid")
  var row1contents = $("<div>").addClass("col-xs-12")
  var row2 = $( "<div>" ).addClass("row-fluid")
  var row2image = $("<div>").addClass("col-xs-5")
  var row2info = $("<div>").addClass("col-xs-7")

  var photo_id = collectionPhoto.photo_id
  data = request.getPhoto( photo_id )

  //title
  row1contents.append( $("<div>")
    .append( $("<h3>")
      .html( photoDetailSpan("name", data.name, photo_id) )
      .attr({"id": "name_" + photo_id, "class":"selectionDetailHeader" } ) ));

  //image
  row2image.append( $("<img>").attr({"src": data.image.image.med.url, "class":"selectionImage" } ) );

  //description and location
  for ( var field in textFields ) {
    row2info.append( $("<div class=\"selectionDetail\"></div>")
      .html( "<span class=\"selectionDetailTitle\">" + textFields[field] + ":</span>")
      .append( photoDetailSpan( field, data[field], photo_id )))
  };

  //related maps
  related_maps = []
  for ( var x = 0; x < data["related_maps"].length; x++ ){
    related_maps.push( data["related_maps"][x].name )
  }

  row2info.append( $("<div class=\"selectionDetail\"></div>").append(
    $( "<span class=\"selectionDetailTitle\"></span>" ).html( "In Maps" ))
    .append( $("<span class=\"selectionDetailAttribute\"  >").html( related_maps.join(",") ) ))

  //Add to map dropdown
  row2info.append( mapSelectionDropdown( container, [photo_id] ) );

  //tag fields
  var tagBase = $("<div class=\"selectionDetail\"></div>").html( "<span class=\"selectionDetailTitle\" id=\"selectionTags_" + photo_id + "\" >Tags:</span>" )
  var tagsList = $("<ul>")
  var tagAdder = $("<div>")

  for (var tagField in tagFields) {

    for (var ii = 0; ii < data[tagField].length; ii++) {
      tagsList.append( $("<li>")
          .html( data[tagField][ii].name )
          .addClass( "SelectionTag round label " + tagFields[tagField] + "Tag" )
          .append( deleteTagButton( data[tagField][ii].id )))
    }

    tagBase.append( $("<div>")
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

  row2info.append( tagBase.append( tagsList) )
  base.append(
        row1.append( row1contents ) )
      .append(
        row2.append(row2image).append(row2info)
      )
  return base
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
          .addClass( "selectionDetailAttribute" )
          .html( value)
          .attr("id", field + "_" + photo_id )
          .bind('dblclick', switchToInput )
}

function switchToInput( event ) {
  var target = $(event.target);
  var input_form =  $( "<input id=\"" + target.attr("id") + "\"></input>" )
          .attr( {"type":"text"} )
          .addClass("string")
          .val( target.html() )
          .keypress( savePhotoData )
  target.html( input_form );
  $("#" + target.attr("id") )
  target.children().first().focus();
}

function mapSelectionDropdown( container, selected_photos_ids ) {

    var base = $( "<div>" ).addClass("selectionDetail")
    base.append( $( "<label>" )
        .attr({ "for": "addSelectionToMapDropdown"})
        .addClass("selectionDetailTitle")
        .html("Add to:")
        .appendTo(base) )

    var selectMapDropDown = $("<select />").attr({"id":"addSelectionToMapDropdown", "name":"addSelectionToMapDropdown"}).addClass("selectpicker");
    var selectMapData = container.related_maps;
    for (var i = 0; i < selectMapData.length; i++) {
        $( $("<option>").attr({"name" : selectMapData[i].name, "value" : selectMapData[i].id })).html(selectMapData[i].name).appendTo(selectMapDropDown);
    };

    selectMapDropDown.appendTo( base );

    $("<button>")
      .attr({"id":"addSelectionToMapButton", "class":"btn btn-sm"})
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
