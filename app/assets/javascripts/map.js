var map;
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 37.7749, lng: -122.4194},
    zoom: 12
  });

  // Add a marker when the user clicks on the map
  var marker = new google.maps.Marker({
    position: {lat: 37.7749, lng: -122.4194},
    map: map,
    draggable: true
  });

  // Update the latitude and longitude input fields when the marker is dragged
  google.maps.event.addListener(marker, 'dragend', function() {
    document.getElementById('latitude-input').value = marker.getPosition().lat();
    document.getElementById('longitude-input').value = marker.getPosition().lng();
  });
}
