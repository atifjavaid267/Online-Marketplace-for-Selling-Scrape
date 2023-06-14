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
var menu = document.getElementById("menu");
var menuButton = document.getElementById("profile-dropdown");

menuButton.addEventListener("mouseenter", () => {
  menu.classList.remove("hidden");
});

menu.addEventListener("mouseleave", () => {
  menu.classList.add("hidden");
});


// navbar
document.addEventListener("turbolinks:load", function () {
  // open
  var mobile = document.querySelectorAll(".mobile-navbar");
  var menu = document.querySelectorAll(".navbar-menu");

  if (mobile.length && menu.length) {
    for (var i = 0; i < mobile.length; i++) {
      mobile[i].addEventListener("click", function () {
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
