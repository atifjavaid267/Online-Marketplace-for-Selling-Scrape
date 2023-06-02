// app/javascript/packs/typewriter.js
document.addEventListener("DOMContentLoaded", function () {
  var i = 0;
  var txt =
    "We offer a streamlined solution for users to sell their meticulously curated products obtained through web scraping. With our user-friendly interface, interested buyers can easily peruse and purchase these unique offerings.";
  var speed = 50;

  function typeWriter() {
    if (i < txt.length) {
      document.getElementById("home_description").innerHTML += txt.charAt(i);
      i++;
      setTimeout(typeWriter, speed);
    }
  }

  typeWriter();
});
