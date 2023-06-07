// notifications
var notificationBell = document.getElementById("notification-bell");
var notificationDropdown = document.getElementById("notification-dropdown");
var userMessage = { senderName: "", message: "" };

var notificationMessage = document.createElement("div");
notificationMessage.textContent = `${userMessage.senderName} ${userMessage.message}`;
notificationMessage.classList.add("p-2", "text-black");
notificationDropdown.appendChild(notificationMessage);

notificationBell.addEventListener("mouseenter", () => {
  notificationDropdown.classList.remove("hidden");
});

notificationDropdown.addEventListener("mouseleave", () => {
  notificationDropdown.classList.add("hidden");
});

// profile dropdown
var menuButton = document.querySelector("#menu-button");
var menu = document.querySelector("#menu");

document.addEventListener("click", event => {
  if (!menu.contains(event.target) && event.target !== menuButton) {
    menu.classList.add("hidden");
    menuButton.setAttribute("aria-expanded", "false");
  }
});

menuButton.addEventListener("click", () => {
  var expanded = menuButton.getAttribute("aria-expanded") === "true" || false;
  menuButton.setAttribute("aria-expanded", !expanded);
  menu.classList.toggle("hidden");
});

// Burger menus navbar
document.addEventListener("DOMContentLoaded", function() {
  // open
  var burger = document.querySelectorAll(".navbar-burger");
  var menu = document.querySelectorAll(".navbar-menu");

  if (burger.length && menu.length) {
    for (var i = 0; i < burger.length; i++) {
      burger[i].addEventListener("click", function() {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle("hidden");
        }
      });
    }
  }

  // close
  var close = document.querySelectorAll(".navbar-close");
  var backdrop = document.querySelectorAll(".navbar-backdrop");

  if (close.length) {
    for (var i = 0; i < close.length; i++) {
      close[i].addEventListener("click", function() {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle("hidden");
        }
      });
    }
  }

  if (backdrop.length) {
    for (var i = 0; i < backdrop.length; i++) {
      backdrop[i].addEventListener("click", function() {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle("hidden");
        }
      });
    }
  }
});
