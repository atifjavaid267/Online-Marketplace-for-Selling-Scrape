// messages.js

document.addEventListener("turbolinks:load", () => {
  if (window.location.pathname === "/messages/new") {
    const countElement = document.getElementById("notification-count");
    localStorage.setItem("count", "0");
    countElement.innerHTML = "0";
    const notificationDropdown = document.getElementById("notification-dropdown");
    notificationDropdown.innerHTML = "";
    localStorage.setItem("notifications", JSON.stringify({ messageCounts: {}, notificationMessages: {} }));
  }
});
