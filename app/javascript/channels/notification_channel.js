import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");

  const notificationDropdown = document.getElementById("notification-dropdown");

  consumer.subscriptions.create(
    { channel: "NotificationChannel", user_id: current_user_id },
    {
      connected() {
        console.log(`Connected to the NotificationsChannel ${current_user_id}`);
      },
      disconnected() {},
      received(data) {
        const countElement = document.getElementById("total-notifications");

        console.log(data);

        // const receiverId = data.receiver_id;
        // const senderName = data.sender_name;
        const orderID = data.order_id;

        countElement.innerHTML = Object.keys(data.notifications).length;

        notificationDropdown.innerHTML = "";

        for (const orderID in data.notifications) {
          const notificationData = Object.keys(data.notifications[orderID]);
          const senderName = notificationData[0];
          const totalMessages = notificationData[1];

          const messageElement = document.createElement("div");
          let str;
          if (totalMessages > 1) {
            str = "messages";
          }
          else {
            str = "message";
          }
          messageElement.textContent = `${senderName} sent you ${totalMessages} ${str}`;
          messageElement.classList.add("dropdown-item");
          notificationMessage.addEventListener("click", () => {
            window.location.href = `/orders/${orderID}/messages/new`;
          });
          notificationDropdown.appendChild(messageElement);
        }
      },
    }
  );
});
