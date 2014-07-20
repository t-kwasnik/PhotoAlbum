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
};
