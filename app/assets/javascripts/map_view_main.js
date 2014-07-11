function loadMainView() {

  var mainView = new MapWindow('main_map');

  var mappedPhotoCollection = new Container("#mapped_photos_container", "Mapped");
  var unmappedPhotoCollection = new Container("#unmapped_photos_container", "Unmapped");

  mainView.containers = {
      "map" : mappedPhotoCollection,
      "unmap" : unmappedPhotoCollection
    };

   mainView.features = request.getPhotos();
   mainView.render();
};
