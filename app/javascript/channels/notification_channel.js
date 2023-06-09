import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");
  const countElement = document.getElementById("notification-count");
  const notificationDropdown = document.getElementById("dropdown");

  const storedCount = localStorage.getItem("count") || 0;
  countElement.innerHTML = storedCount;

  const storedNotifications =
    JSON.parse(localStorage.getItem("notifications")) || {};
  const messageCounts = storedNotifications.messageCounts || {};
  const notificationMessages = storedNotifications.notificationMessages || {};

  for (const pairId in messageCounts) {
    const senderId = pairId.split("-")[0];
    const senderName = notificationMessages[pairId].senderName;
    const messageCount = messageCounts[pairId];
    const orderID = notificationMessages[pairId].orderID;

    const notificationMessage = document.createElement("div");
    notificationMessage.textContent = `${senderName} sent you ${messageCount} messages`;
    notificationMessage.classList.add("p-2", "text-white");
    notificationMessage.id = `notification-${pairId}`;
    notificationMessage.addEventListener("click", () => {
      const messageURL = `/orders/${orderID}/messages/new`;
      localStorage.setItem("count", 0);
      localStorage.setItem("notifications", JSON.stringify({}));
      window.location.href = messageURL;
    });
    notificationDropdown.appendChild(notificationMessage);
  }

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
      notificationMessage.classList.add("p-2", "text-white");
      notificationMessage.id = `notification-${pairId}`;
      notificationMessage.addEventListener("click", () => {
        const messageURL = `/orders/${orderID}/messages/new`;
        localStorage.setItem("count", 0);
        localStorage.setItem("notifications", JSON.stringify({}));
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

    const notifications = {
      messageCounts,
      notificationMessages
    };
    localStorage.setItem("notifications", JSON.stringify(notifications));

    const newCount = Object.values(messageCounts).reduce(
      (total, count) => total + count,
      0
    );
    localStorage.setItem("count", newCount);
    countElement.innerHTML = newCount;
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
});
