function hideFlashMessages() {
  const flashMessages = document.querySelectorAll(".alert-dismissible");

  flashMessages.forEach(message => {
    const closeButton = message.querySelector(".close");

    closeButton.addEventListener("click", () => {
      message.remove();
    });

    message.classList.add("hide-flash");

    setTimeout(() => {
      message.remove();
    }, 5000);
  });
}

document.addEventListener("turbolinks:load", () => {
  hideFlashMessages();
});
