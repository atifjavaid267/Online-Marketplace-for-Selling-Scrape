import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "controllers";
import "../packs/flashes.js";


Rails.start();
Turbolinks.start();
ActiveStorage.start();

window.fireMapsLoadedEvent = function () {
  const evt = new Event("mapsLoaded");
  document.dispatchEvent(evt);
};

