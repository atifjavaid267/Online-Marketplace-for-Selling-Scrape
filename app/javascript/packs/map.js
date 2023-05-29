function initMap() {
  var geocoder;
  var map;
  var marker;
  var input = document.getElementById("pac-input");
  var fullAddressInput = document.getElementById("address_full_address");

  map = new google.maps.Map(document.getElementById("map"), {
    zoom: 6,
    center: { lat: 30.3753, lng: 69.3451 },
    zoomControl: true,
  });
  marker = new google.maps.Marker({
    position: { lat: 30.3753, lng: 69.3451 },
    map: map,
    draggable: true,
  });

  google.maps.event.addListener(map, "click", function (event) {
    marker.setPosition(event.latLng);
    map.panTo(event.latLng);
  });

  google.maps.event.addListener(marker, "dragend", function (event) {
    geocodeLatLng(event.latLng);
    map.panTo(event.latLng);
  });

  geocoder = new google.maps.Geocoder();
  var autocomplete = new google.maps.places.Autocomplete(input);
  autocomplete.bindTo("bounds", map);

  autocomplete.addListener("place_changed", function () {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      alert("No details available for input: " + place.name);
      return;
    }

    map.setCenter(place.geometry.location);
    marker.setPosition(place.geometry.location);
    map.setZoom(18);

    var address_components = place.address_components;
    var route = "";
    var city = "";
    var state = "";
    var zip_code = "";
    for (var i = 0; i < address_components.length; i++) {
      var component = address_components[i];

      if (component.types.includes("locality")) {
        city = component.long_name;
      } else if (component.types.includes("administrative_area_level_1")) {
        state = component.long_name;
      } else if (component.types.includes("postal_code")) {
        zip_code = component.long_name;
      }
    }

    document.getElementById("address_city").value = city;
    document.getElementById("address_state").value = state;
    document.getElementById("address_zip_code").value = zip_code;

    var address = {
      city: city,
      state: state,
      zip_code: zip_code,
    };

    fullAddressInput.value = place.formatted_address;

    document.getElementById("map").focus();
    console.log(address);
  });

  function geocodeLatLng(latlng) {
    geocoder.geocode({ location: latlng }, function (results, status) {
      if (status === "OK") {
        if (results[0]) {
          var latitude = results[0].geometry.location.lat();
          var longitude = results[0].geometry.location.lng();

          var address_components = results[0].address_components;

          var route = "";
          var city = "";
          var state = "";
          var zip_code = "";
          var full_address = results[0].formatted_address;

          for (var i = 0; i < address_components.length; i++) {
            var component = address_components[i];

            if (component.types.includes("locality")) {
              city = component.long_name;
            } else if (
              component.types.includes("administrative_area_level_1")
            ) {
              state = component.long_name;
            } else if (component.types.includes("postal_code")) {
              zip_code = component.long_name;
            }
          }

          document.getElementById("latitude").value = latitude;
          document.getElementById("longitude").value = longitude;
          fullAddressInput.value = full_address;

          document.getElementById("address_city").value = city;
          document.getElementById("address_state").value = state;
          document.getElementById("address_zip_code").value = zip_code;

          var address = {
            city: city,
            state: state,
            zip_code: zip_code,
          };
          console.log(address);
          fullAddressInput.value = full_address;
        } else {
          window.alert("No results found");
        }
      } else {
        window.alert("Geocoder failed due to: " + status);
      }
    });
  }
}

window.initMap = initMap;

