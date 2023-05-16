import consumer from "./consumer";
document.addEventListener("turbolinks:load", () => {
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
        const messagesContainer = document.getElementById("messages");

        if (userDiv && messagesContainer) {
          let messageHtml;
          const current_user_id = parseInt(
            userDiv.getAttribute("data-user-id")
          );

          if (data.sender_id === current_user_id) {
            messageHtml = `
            <div class="message text-right mr-5 mt-5">
              <span class="time text-xs text-gray-500">${data.timestamp}</span>
              <span class="content bg-blue-600 rounded-full px-3 py-2 m-1 text-white text-lg">${data.message}</span>
            </div>
          `;
          } else {
            messageHtml = `
            <div class="message  text-left ml-5 mt-5">

              <span class="content bg-gray-500 rounded-full px-3 py-2 m-1 text-white text-lg">${data.message}</span>
              <span class="time text-xs text-gray-500">${data.timestamp}</span>
            </div>
          `;
          }

          messagesContainer.insertAdjacentHTML("beforeend", messageHtml);
          const inputField = document.getElementById("message_content");
          inputField.value = "";
        }
        if (window.location.pathname === "/messages/new") {
          const countElement = document.getElementById("count");
          localStorage.setItem("count", " ");
          countElement.innerHTML = "";
        }
      },
    }
  );
});
