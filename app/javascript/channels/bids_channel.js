import consumer from "./consumer";

consumer.subscriptions.create("BidsChannel", {
  connected() {
    console.log("Connected to the BidsChannel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },
  received(data) {
    console.log("received data:", data);
    const { ad_id, price, buyer_id, buyer_name } = data;
    const bidsContainer = document.getElementById(`bids-container-${ad_id}`);
    const html = `
      <div class="flex justify-between items-center p-4 border rounded-md shadow-md">
        <div>
          <p class="text-gray-600 font-bold">
            <span class="font-bold"> Bid Amount: </span>${price}
          </p>
          <p class="text-lg">Buyer ID: ${buyer_id}</p>
          <p class="text-lg">Buyer Name: ${buyer_name}</p>
        </div>
        <div>
          <a href="${data.order_path}" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-600 focus:ring-opacity-50">Make Order</a>
        </div>
      </div>
    `;
    bidsContainer.insertAdjacentHTML("beforeend", html);
  },
  // received(data) {
  //   console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..");
  //   const { ad_id, price, buyer_id, buyer_name } = data;
  //   console.log(ad_id);
  //   console.log(price);
  //   console.log(buyer_id);
  //   console.log(buyer_name);
  //   // debugger;
  //   const bidsContainer = document.getElementById(`bids-container-${ad_id}`);
  //   const html = `<div><p class="text-gray-600 font-bold">
  //   <span class="font-bold"> Bid Amount: </span>${price}
  // </p><p class="text-lg">Buyer ID: ${buyer_id}</p><p class="text-lg">Buyer Name: ${buyer_name}</p></div>`;
  //   bidsContainer.insertAdjacentHTML("beforeend", html);
  // },

  // const newBid = document.createElement("div");

  // newBid.textContent = `New bid: $${price}`;
  // bidsContainer.prepend(html);

  // const $bidsContainer = document.querySelector(`#bids-container-${ad_id}`);
  // const $newBid = document.createElement("div");

  // // window.location.reload();
  // $newBid.textContent = `New bid: $${price}`;
  // $bidsContainer.prepend($newBid);

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
