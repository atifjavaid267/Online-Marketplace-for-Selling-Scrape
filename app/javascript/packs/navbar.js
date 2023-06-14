var notificationBell = document.getElementById("notification-bell");
var notificationDropdown = document.getElementById("notifications-dropdown");

notificationBell.addEventListener("mouseenter", () => {
  notificationDropdown.classList.remove("hidden");
});

notificationDropdown.addEventListener("mouseleave", () => {
  notificationDropdown.classList.add("hidden");
});



const notifications = JSON.parse(document.getElementById("notification-data").getAttribute("notification-data-id"));

if (notificationDropdown) {
  notificationDropdown.innerHTML = "";
}
for (const orderID in notifications) {
  const notificationData = notifications[orderID];
  const senderName = notificationData[0];
  const totalMessages = notificationData[1];
  const messageElement = document.createElement("div");

  messageElement.textContent = `${senderName} sent you ${totalMessages} ${ totalMessages > 1 ? "messages" : "message"}`;
  messageElement.addEventListener("click", () => {
    window.location.href = `/orders/${orderID}/messages/new`;
  });
  notificationDropdown.appendChild(messageElement);
}

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
document.addEventListener("turbolinks:load", function () {
  // open
  var burger = document.querySelectorAll(".navbar-burger");
  var menu = document.querySelectorAll(".navbar-menu");

  if (burger.length && menu.length) {
    for (var i = 0; i < burger.length; i++) {
      burger[i].addEventListener("click", function () {
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
      close[i].addEventListener("click", function () {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle("hidden");
        }
      });
    }
  }

  if (backdrop.length) {
    for (var i = 0; i < backdrop.length; i++) {
      backdrop[i].addEventListener("click", function () {
        for (var j = 0; j < menu.length; j++) {
          menu[j].classList.toggle("hidden");
        }
      });
    }
  }
});
