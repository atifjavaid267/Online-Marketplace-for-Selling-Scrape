// var map;
// function initMap() {
//   // debugger;
//   map = new google.maps.Map(document.getElementById("map"), {
//     center: { lat: 37.7749, lng: -122.4194 },
//     zoom: 12,
//   });

//   // Add a marker when the user clicks on the map
//   var marker = new google.maps.Marker({
//     position: { lat: 37.7749, lng: -122.4194 },
//     map: map,
//     draggable: true,
//   });

//   // Update the latitude and longitude input fields when the marker is dragged
//   google.maps.event.addListener(marker, "dragend", function () {
//     document.getElementById("latitude-input").value = marker
//       .getPosition()
//       .lat();
//     document.getElementById("longitude-input").value = marker
//       .getPosition()
//       .lng();
//   });
// }

// // function initMap() {
// //   const coords = document.getElementById("breweries");
// //   debugger;
// //   const city = {
// //     lat: coords.getAttribute("data-latitude"),
// //     lng: coords.getAttribute("data-longitude"),
// //   };

// //   const map = new google.maps.Map(document.getElementById("map"), {
// //     zoom: 10,
// //     center: city,
// //   });

// //   const breweries = document.querySelectorAll("li.brewery-list-item");
// //   breweries.forEach((brewery) => {
// //     const marker = new google.maps.Marker({
// //       position: {
// //         lat: brewery.getAttribute("data-latitude"),
// //         lng: brewery.getAttribute("data-longitude"),
// //       },
// //       map: map,
// //     });
// //   });
// // }

// // window.initMap = initMap;
