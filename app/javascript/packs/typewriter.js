// app/javascript/packs/typewriter.js
document.addEventListener("DOMContentLoaded", function () {
  var i = 0;
  const txt =
    "We offer a streamlined solution for users to sell their meticulously curated products obtained through web scraping. With our user-friendly interface, interested buyers can easily peruse and purchase these unique offerings.";

  function typeWriter() {
    if (i < txt.length) {
      document.getElementById("home_description").innerHTML += txt.charAt(i);
      i++;
      setTimeout(typeWriter, 50);
    }
  }

  typeWriter();
});
