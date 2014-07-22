function checkStandardInput( event ) {
  var field = $( event.target ).attr( "name" )
  var value = $( event.target ).val()
  var elem_id = $( event.target ).attr( "id" )
  var data = {}
  data[field] = value

  var result = request.checkUser( data )

  if ( result[elem_id] == true ) {
    $("div." + elem_id + " i").attr("class","fa fa-check-circle-o signUpSuccess")
  } else {
    $("div." + elem_id + " i").attr("class","fa fa-ban signUpFail")
  }

}

function checkPasswordConfirmation( event ) {
  var password = $("#signUp div.user_password input").val()
  if ( $(event.target).val() == password ) {
    $( "div.user_password_confirmation i" ).attr("class","fa fa-check-circle-o signUpSuccess")
    $("#signUp form button").show()
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

   $("#signUp div.input").append("<i></i>")
   $("#signUp form button").hide()
   $("div.user_username input").focusout( checkStandardInput )
   $("div.user_email input").focusout( checkStandardInput )
   $("div.user_password input").focusout( checkStandardInput )
   $("div.user_password input").keypress( function( event ){
      $( "div.user_password_confirmation input" ).val("")
      $("#signUp form button").hide()
   } )
  $( "div.user_password_confirmation input" ).keyup( checkPasswordConfirmation )
};
