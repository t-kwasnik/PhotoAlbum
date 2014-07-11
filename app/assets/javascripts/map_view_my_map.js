function loadMyMapView() {

  var myMapView = new MapWindow('my_map');

  var mappedPhotoCollection = new Container("#mapped_photos_container", "Mapped");
  var unmappedPhotoCollection = new Container("#unmapped_photos_container", "Unmapped");

  myMapView.containers = {
      "map" : mappedPhotoCollection,
      "unmap" : unmappedPhotoCollection
    };

   myMapView.features = request.getPhotos();
   myMapView.render();
};
