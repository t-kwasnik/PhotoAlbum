self.addEventListener('message', function(e) {
  var files = document.getElementById('photosToMap').files;
  var formData = new FormData();
  for (var i = 0; i < files.length; i++) {
    var formData = new FormData();
    var file = files[i];
    formData.append('photo[image]', file, file.name);
    debugger
    serverResult = request.createPhoto(formData);
    if ( serverResult != false ) {
      parseNewPhoto( photosView, serverResult )
    }
  };
}, false );
