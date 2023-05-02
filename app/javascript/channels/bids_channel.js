import consumer from "./consumer";

consumer.subscriptions.create("BidsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const { ad_id, price } = data;
    const $bidsContainer = document.querySelector(`#bids-container-${ad_id}`);
    const $newBid = document.createElement("div");

    // window.location.reload();
    $newBid.textContent = `New bid: $${price}`;
    $bidsContainer.prepend($newBid);
  },
  // received(data) {
  //   const { ad_id, price } = data;
  //   const $bidsContainer = document.querySelector(`#bids-container-${ad_id}`);
  //   const $newBid = document.createElement("div");
  //   window.location.reload();
  //   $newBid.textContent = `New bid: $${price}`;
  //   $bidsContainer.prepend($newBid);

  //   // Called when there's incoming data on the websocket for this channel
  // },
});
