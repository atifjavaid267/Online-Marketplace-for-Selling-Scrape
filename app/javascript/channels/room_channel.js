import consumer from "./consumer";
document.addEventListener("turbolinks:load", () => {
  const countElement = document.getElementById("count");
  const messagesContainer = document.getElementById("messages");

  consumer.subscriptions.create(
    { channel: "RoomChannel", room_id: 1 },
    {
      connected() {
        console.log("Connected to the RoomChannel");
      },

      disconnected() {
        console.log("Disconnected from the RoomChannel");
      },

      received(data) {
        console.log(data);
        const userDiv = document.getElementById("user");

        if (userDiv && messagesContainer) {
          let messageHtml;
          const current_user_id = parseInt(
            userDiv.getAttribute("data-user-id")
          );

          if (data.sender_id === current_user_id) {
            messageHtml = `
              <div class="message text-right mr-5 mt-3 mb-7">
                <span class="time text-xs text-gray-500">${data.timestamp}</span>
                <span class="content bg-blue-600 rounded-full px-3 py-2 m-1 text-white text-lg">${data.message}</span>
              </div>
            `;
          } else {
            messageHtml = `
              <div class="message text-left ml-5 mt-3 mb-7">
                <span class="content bg-gray-500 rounded-full px-3 py-2 m-1 text-white text-lg">${data.message}</span>
                <span class="time text-xs text-gray-500">${data.timestamp}</span>
              </div>
            `;
          }

          messagesContainer.insertAdjacentHTML("beforeend", messageHtml);
          const inputField = document.getElementById("message_content");
          inputField.value = "";
        }

        if (countElement && parseInt(countElement.innerHTML) === 0) {
          const notificationDropdown = document.getElementById(
            "notification-dropdown"
          );
          if (notificationDropdown) {
            notificationDropdown.innerHTML = "";
          }
        }
      },
    }
  );

  if (window.location.pathname === `/orders/${orderID}/messages/new`) {
    const countElement = document.getElementById("notification-count");
    localStorage.setItem("count", "0");
    countElement.innerHTML = "0";
    const notificationDropdown = document.getElementById(
      "notification-dropdown"
    );
    if (notificationDropdown) {
      notificationDropdown.innerHTML = "";
    }
    localStorage.setItem(
      "notifications",
      JSON.stringify({ messageCounts: {}, notificationMessages: {} })
    );
  }
});
