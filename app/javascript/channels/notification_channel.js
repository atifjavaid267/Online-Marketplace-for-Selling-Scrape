import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");
  const countElement = document.getElementById("notification-count");
  const notificationDropdown = document.getElementById("dropdown");

<<<<<<< Updated upstream
  const storedCount = parseInt(countElement.innerHTML) || 0;
  let messageCounts = {};
  let notificationMessages = {};

  const updateCount = (count) => {
    countElement.innerHTML = count;
  };

  const createNotificationElement = (
    pairId,
    senderName,
    messageCount,
    orderID
  ) => {
    const notificationMessage = document.createElement("div");
    notificationMessage.textContent = `${senderName} sent you ${messageCount} messages`;
    notificationMessage.classList.add("p-2", "text-white");
    notificationMessage.id = `notification-${pairId}`;
    notificationMessage.addEventListener("click", () => {
      const messageURL = `/orders/${orderID}/messages/new`;
      window.location.href = messageURL;
    });
    return notificationMessage;
  };

  for (const pairId in messageCounts) {
    const senderId = pairId.split("-")[0];
    const senderName = notificationMessages[pairId].senderName;
    const messageCount = messageCounts[pairId];
    const orderID = notificationMessages[pairId].orderID;

    const notificationMessage = createNotificationElement(
      pairId,
      senderName,
      messageCount,
      orderID
    );
    notificationDropdown.appendChild(notificationMessage);
  }
=======
>>>>>>> Stashed changes

  const handleNotification = (data) => {
    console.log(data);
    const receiverId = data.receiver_id;
    const senderName = data.sender_name;
    const orderID = data.order_id;
<<<<<<< Updated upstream

    const pairId = `${senderId}-${receiverId}`;
    const existingMessage = document.getElementById(`notification-${pairId}`);

    if (existingMessage) {
      const messageCount = messageCounts[pairId];
      existingMessage.textContent = `${senderName} sent you ${
        messageCount + 1
      } messages`;
      messageCounts[pairId] += 1;
    } else {
      const notificationMessage = createNotificationElement(
        pairId,
        senderName,
        1,
        orderID
      );
      notificationDropdown.appendChild(notificationMessage);
      messageCounts[pairId] = 1;
    }

    notificationMessages[pairId] = {
      senderName,
      messageCount: messageCounts[pairId],
      orderID,
    };

    const newCount = Object.values(messageCounts).reduce(
      (total, count) => total + count,
      0
    );
    updateCount(newCount);
=======
    const notifications = data.notifications

>>>>>>> Stashed changes
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
