import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");
  const countElement = document.getElementById("notification-count");
  const notificationDropdown = document.getElementById("dropdown");

  const handleNotification = (data) => {

    console.log(data);

    const receiverId = data.receiver_id;
    const senderName = data.sender_name;
    const orderID = data.order_id;
    const notifications = data.notifications
  };

  consumer.subscriptions.create(
    { channel: "NotificationChannel", user_id: current_user_id },
    {
      connected() {
        console.log(`Connected to the NotificationsChannel ${current_user_id}`);
      },
      disconnected() {},
      received(data) {
        handleNotification(data);
      },
    }
  );
});
