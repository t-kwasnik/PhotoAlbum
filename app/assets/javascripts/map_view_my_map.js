function loadMyMapView() {

  var myMapView = new MapWindow('my_map');

  var mappedPhotoCollection = new Panel("#mapped_photos_container", "Mapped");
  var unmappedPhotoCollection = new Panel("#unmapped_photos_container", "Unmapped");

  myMapView.containers = {
      "map" : mappedPhotoCollection,
      "unmap" : unmappedPhotoCollection
    };

   myMapView.features = request.getPhotos();
   myMapView.render();
};
