import consumer from "./consumer";
document.addEventListener("turbolinks:load", () => {
  consumer.subscriptions.create(
    { channel: "RoomChannel", room_id: 1 },

    {
      connected() {
        // Called when the subscription is ready for use on the server"
        console.log("Connected to the RoomChannel");
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log("Disconnected from the RoomChannel");
      },

      received(data) {
        console.log("received");
        // Called when there's incoming data on the websocket for this channel
        console.log(data);
        console.log("message received");
        const messagesContainer = document.getElementById("messages");
        const senderName = data.sender_id;
        const receiverName = data.receiver_id;
        const messageContent = data.message;
        const timestamp = data.timestamp;
        const messageHtml = `
          <div class="message">
            <div class="message-header text-red-500">
              <span class="sender">${senderName}</span>
              <span class="receiver">${receiverName}</span>
              <span class="timestamp">${timestamp}</span>
            </div>
            <div class="message-content">${messageContent}</div>
          </div>
        `;
        messagesContainer.insertAdjacentHTML("beforeend", messageHtml);
        const inputField = document.getElementById("message_content");
        inputField.value = "";
      },

      send(data) {
        console.log("send");
        const messageInput = document.getElementById("message_content");
        const messageContent = messageInput.value;

        const messageData = {
          content: messageContent,
          sender_id: senderId,
          receiver_id: receiverId,
          room_id: 1,
        };

        this.perform("send", messageData);
        messageInput.value = "";
      },
    }
  );
});
