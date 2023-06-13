import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");

  const notificationDropdown = document.getElementById(
    "notifications-dropdown"
  );

  consumer.subscriptions.create(
    { channel: "NotificationChannel", user_id: current_user_id },
    {
      connected() {
        console.log(`Connected to the NotificationsChannel ${current_user_id}`);
      },
      disconnected() {},
      received(data) {
        const countElement = document.getElementById("total-notifications");

        console.log("============================");
        console.log(data);
        console.log("============================");

        const receiverId = data.receiver_id;
        const senderName = data.sender_name;
        const orderID = data.order_id;

        countElement.innerHTML = Object.keys(data.notifications).length;

        notificationDropdown.innerHTML = "";

        for (const orderID in data.notifications) {
          const senderNames = Object.keys(data.notifications[orderID]);
          const messageCount = data.notifications[orderID][senderNames[0]];

          const messageElement = document.createElement("div");
          messageElement.textContent = `${senderNames[0]} sent you ${messageCount} message(s)`;
          messageElement.classList.add("dropdown-item");

          notificationDropdown.appendChild(messageElement);
        }
      },
    }
  );
});
