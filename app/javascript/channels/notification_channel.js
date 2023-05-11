import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const userDiv = document.getElementById("user");
  const current_user_id = userDiv.getAttribute("data-user-id");
  consumer.subscriptions.create(
    { channel: "NotificationChannel", user_id: current_user_id },
    {
      connected() {
        console.log(`Connected to the NotificationsChannel ${current_user_id}`);

        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        console.log(data);
        const countElement = document.getElementById("count");
        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        console.log(data.count);
        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        countElement.innerHTML = data.count;
        // Called when there's incoming data on the websocket for this channel
        // const notificationCountElement =
        //   // document.getElementById("notification-count");
        // // const currentCount = parseInt(notificationCountElement.innerText);
        // const newCount = currentCount + data.count;
        // notificationCountElement.innerText = newCount;
        // You could also add additional logic here to update the UI with
        // any other relevant information from the incoming data.
      },
    }
  );
});
