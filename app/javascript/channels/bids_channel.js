import consumer from "./consumer";

consumer.subscriptions.create("BidsChannel", {
  connected() {
    console.log("Connected to the BidsChannel");
  },

  disconnected() {
  },
  received(data) {
    console.log("received data:", data);
    const { ad_id, price, buyer_name } = data;
    const bidsContainer = document.getElementById(`bids-container-${ad_id}`);
    const html = `
      <div class="flex justify-between items-center p-4 border rounded-md shadow-md">
        <div>
          <p class="text-gray-600 font-bold">
            <span class="font-bold"> Bid Amount: </span>${price}
          </p>
          <p class="text-lg">Buyer Name: ${buyer_name}</p>
        </div>
        <div>
          <a href="${data.order_path}" class="px-4 py-3 mr-2 bg-green-500 text-white rounded hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-blue-600 focus:ring-opacity-50">Create Order</a>
        </div>
      </div>
    `;
    bidsContainer.insertAdjacentHTML("beforeend", html);
  },
});
