function checkInput( event ) {
  var field = $( event.target ).attr( "name" )
  var value = $( event.target ).val()
  var elem_id = $( event.target ).attr( "id" )
  var data = {}
  data[field] = value

  var result = request.checkUser( data )
  var outcome
  if ( $( event.target ).attr( "name" ) == "user[password_confirmation]" ) {
    var password = $("#signUp div.user_password input").val()
    if ( $(event.target).val() == password ) {
      outcome = true
    } else {
      outcome = false
    }
  } else {
      outcome = result[elem_id]
  }

  if ( outcome == true) {
    $("div." + elem_id + " i").attr("class","fa fa-check-circle-o signUpSuccess")
  } else {
    $("div." + elem_id + " i").attr("class","fa fa-ban signUpFail")
  }

  var successes = 0
  for ( var i = 0; i < $("#signUp div.input i").length; i++ ) {
    if ( $( $("#signUp div.input i")[i]).hasClass("fa fa-check-circle-o signUpSuccess") ) {
      successes++
    }
  }

  if ( successes == 4 ){
    $("#signUp form button").show()
  } else {
    $("#signUp form button").hide()
  }
}

function loadMainView() {

  var mainView = new MapWindow('main_map');

  var mappedPhotoCollection = new Panel("#mapped_photos_container", "Mapped");
  var unmappedPhotoCollection = new Panel("#unmapped_photos_container", "Unmapped");

  mainView.containers = {
      "map" : mappedPhotoCollection,
      "unmap" : unmappedPhotoCollection
    };

   mainView.features = request.getMainPhotos;
   mainView.startUp();

   $( "#signUp div.input").append("<i></i>")
   $( "#signUp form button").hide()
   $( "#signUp input" ).keyup( checkInput )
   $( "#signUp input" ).keypress( function( event ){
      if ( event.keyCode == 13 ) {
        event.preventDefault();
      }
   })
   $( "div.user_password input").click( function( event ){
      $( "div.user_password_confirmation input" ).val("")
      $( "div.user_password_confirmation i" ).attr("class","none")
   } )

};
