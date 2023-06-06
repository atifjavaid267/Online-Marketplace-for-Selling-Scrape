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

var menuButton = document.querySelector("#menu-button");
var menu = document.querySelector("#menu");

document.addEventListener("click", (event) => {
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
