request = {
  "getPhotos" : function() {
    var data = ""
    $.ajax({
        url: '/photos.json',
        dataType: 'json',
        async: false,
        success: function(d) {
              data = d;
        }
    })
    return data
  },
  "getPhoto" : function( photo_id ) {
    var data = ""
    $.ajax({
        url: '/photos/'+ photo_id + '.json',
        dataType: 'json',
        async: false,
        success: function(d) {
              data = d;
        }
    })
    return data
  },
  "getMyMaps" : function() {
    var data = ""
    $.ajax({
        url: '/my_maps.json',
        dataType: 'json',
        async: false,
        success: function(d) {
              data = d;
        }
    })
    return data
  },
  "createMyMapPhoto" : function(map_id, photo_id) {
    var response = false;
    $.ajax({
          type: "POST",
          url: '/my_maps/' + map_id + '/my_map_photos',
          data: { my_map_photo: {"photo_id": photo_id, "order": photo_id }},
          async: false,
          dataType: "json"
     });
    response = true;
    return response;
  }
};
