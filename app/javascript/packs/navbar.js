// notifications
var notificationBell = document.getElementById("notification-bell");
var notificationDropdown = document.getElementById("dropdown");
var userMessage = { senderName: "", message: "" };

var notificationMessage = document.createElement("div");
notificationMessage.textContent = `${userMessage.senderName} ${userMessage.message}`;
notificationDropdown.appendChild(notificationMessage);

notificationBell.addEventListener("mouseenter", () => {
  notificationDropdown.classList.remove("hidden");
});

notificationDropdown.addEventListener("mouseleave", () => {
  notificationDropdown.classList.add("hidden");
});

// profile dropdown
var menuButton = document.getElementById("profile-dropdown");
var menu = document.getElementById("menu");

menuButton.addEventListener("mouseenter", () => {
  menu.classList.remove("hidden");
});

menu.addEventListener("mouseleave", () => {
  menu.classList.add("hidden");
});

function hideMenu() {
  menu.classList.add("hidden");
}

document.addEventListener("click", (event) => {
  const target = event.target;

  if (!menu.contains(target) && !menuButton.contains(target)) {
    hideMenu();
  }
});

// Burger menus navbar
document.addEventListener("turbolinks:load", function() {
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
