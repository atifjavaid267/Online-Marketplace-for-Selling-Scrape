import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const currentUserId = userDiv.getAttribute("user-id");

  consumer.subscriptions.create(
    { channel: "NotificationChannel", user_id: currentUserId },
    {
      connected() {},
      disconnected() {},
      received(data) {
        const countElement = document.getElementById("total-notifications");
        const notificationDropdown = document.getElementById(
          "notifications-dropdown"
        );

        countElement.innerHTML = Object.keys(data.notifications).length;

        if (notificationDropdown) {
          notificationDropdown.innerHTML = "";
        }

        for (const orderID in data.notifications) {
          const notificationData = data.notifications[orderID];
          const senderName = notificationData[0];
          const totalMessages = notificationData[1];
          const messageElement = document.createElement("div");

          messageElement.textContent = `${senderName} sent you ${totalMessages} ${totalMessages >
          1
            ? "messages"
            : "message"}`;
          messageElement.addEventListener("click", () => {
            window.location.href = `/orders/${orderID}/messages/new`;
          });
          notificationDropdown.appendChild(messageElement);
        }
      }
    }
  );
});
