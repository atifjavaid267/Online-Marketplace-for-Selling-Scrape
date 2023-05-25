import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");
  const countElement = document.getElementById("notification-count");
  const notificationDropdown = document.getElementById("notification-dropdown");

  const storedCount = localStorage.getItem("count") || 0;
  countElement.innerHTML = storedCount;

  const storedNotifications =
    JSON.parse(localStorage.getItem("notifications")) || {};
  const messageCounts = storedNotifications.messageCounts || {};
  const notificationMessages = storedNotifications.notificationMessages || {};

  for (const senderId in messageCounts) {
    const senderName = notificationMessages[senderId].senderName;
    const messageCount = messageCounts[senderId];
    const orderID = notificationMessages[senderId].orderID;

    const notificationMessage = document.createElement("div");
    notificationMessage.textContent = `${senderName} sent you ${messageCount} messages`;
    notificationMessage.classList.add("p-2", "text-black");
    notificationMessage.id = `notification-${senderId}`;
    notificationMessage.addEventListener("click", () => {
      const messageURL = `/messages/new?order_id=${orderID}&user_id=${current_user_id}`;
      window.location.href = messageURL;
    });
    notificationDropdown.appendChild(notificationMessage);
  }

  const handleNotification = (data) => {
    console.log(data);
    const senderId = data.sender_id;
    const senderName = data.sender_name;
    const orderID = data.order_id;

    const messageCount = messageCounts[senderId] || 0;
    const existingMessage = document.getElementById(`notification-${senderId}`);

    if (existingMessage) {
      existingMessage.textContent = `${senderName} sent you ${
        messageCount + 1
      } messages`;
    } else {
      const notificationMessage = document.createElement("div");
      notificationMessage.textContent = `${senderName} sent you a message`;
      notificationMessage.classList.add("p-2", "text-black");
      notificationMessage.id = `notification-${senderId}`;
      notificationMessage.addEventListener("click", () => {
        const messageURL = `/messages/new?order_id=${orderID}&user_id=${current_user_id}`;
        window.location.href = messageURL;
      });
      notificationDropdown.appendChild(notificationMessage);
    }

    messageCounts[senderId] = messageCount + 1;
    notificationMessages[senderId] = {
      senderName,
      messageCount: messageCount + 1,
      orderID,
    };

    const notifications = {
      messageCounts,
      notificationMessages,
    };
    localStorage.setItem("notifications", JSON.stringify(notifications));

    const newCount = parseInt(countElement.innerHTML) + 1;
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

      // received(data) {
      // handleNotification(data);
      received(data) {
        const senderId = data.sender_id;
        const senderName = data.sender_name;
        const orderID = data.order_id;

        const storedNotifications =
          JSON.parse(localStorage.getItem("notifications")) || {};
        const messageCounts = storedNotifications.messageCounts || {};
        const notificationMessages =
          storedNotifications.notificationMessages || {};

        const messageCount = messageCounts[senderId] || 0;
        const existingMessage = document.getElementById(
          `notification-${senderId}`
        );

        if (existingMessage) {
          existingMessage.textContent = `${senderName} sent you ${
            messageCount + 1
          } messages`;
        } else {
          const notificationMessage = document.createElement("div");
          notificationMessage.textContent = `${senderName} sent you a message`;
          notificationMessage.classList.add("p-2", "text-black");
          notificationMessage.id = `notification-${senderId}`;
          notificationMessage.addEventListener("click", () => {
            const messageURL = `/messages/new?order_id=${orderID}&user_id=${current_user_id}`;
            window.location.href = messageURL;
          });
          notificationDropdown.appendChild(notificationMessage);
        }

        messageCounts[senderId] = messageCount + 1;
        notificationMessages[senderId] = {
          senderName,
          messageCount: messageCount + 1,
          orderID,
        };

        const notifications = {
          messageCounts,
          notificationMessages,
        };
        localStorage.setItem("notifications", JSON.stringify(notifications));

        const storedCount = parseInt(localStorage.getItem("count")) || 0;
        const newCount = storedCount + 1;
        localStorage.setItem("count", newCount);
        countElement.innerHTML = newCount;
      },
    }
  );
});
