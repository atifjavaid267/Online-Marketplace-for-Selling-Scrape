import consumer from "./consumer";

let notificationCount = 0;

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");
  const countElement = document.getElementById("notification-count");
  const notificationDropdown = document.getElementById("notification-dropdown");
  const storedNotifications = userDiv.getAttribute("data-notifications");
  const { messageCounts = {}, notificationMessages = {} } =
    JSON.parse(storedNotifications) || {};

  const handleNotification = data => {
    console.log(data);
    const senderId = data.sender_id;
    const receiverId = data.receiver_id;
    const senderName = data.sender_name;
    const orderID = data.order_id;

    const pairId = `${senderId}-${receiverId}`;
    const existingMessage = document.getElementById(`notification-${pairId}`);

    if (existingMessage) {
      const messageCount = messageCounts[pairId];
      existingMessage.textContent = `${senderName} sent you ${messageCount +
        1} messages`;
      messageCounts[pairId] += 1;
    } else {
      const notificationMessage = document.createElement("div");
      notificationMessage.textContent = `${senderName} sent you a message`;
      notificationMessage.classList.add("p-2", "text-black");
      notificationMessage.id = `notification-${pairId}`;
      notificationMessage.addEventListener("click", () => {
        const messageURL = `/orders/${orderID}/messages/new`;
        window.location.href = messageURL;
      });
      notificationDropdown.appendChild(notificationMessage);
      messageCounts[pairId] = 1;
    }

    notificationMessages[pairId] = {
      senderName,
      messageCount: messageCounts[pairId],
      orderID
    };

    notificationCount = Object.values(messageCounts).reduce(
      (total, count) => total + count,
      0
    );

    countElement.innerHTML = notificationCount.toString();
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
      }
    }
  );

  countElement.innerHTML = notificationCount.toString();
});
