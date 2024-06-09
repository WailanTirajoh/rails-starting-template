// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "./controllers";

Turbo.setConfirmMethod((message, element) => {
  let dialog = document.getElementById("turbo-confirm");

  dialog.querySelector("#dialog-modal-label").textContent = message;
  dialog.showModal();

  return new Promise((resolve, rej) => {
    dialog.addEventListener(
      "close",
      () => {
        resolve(dialog.returnValue == "confirm");
      },
      {
        once: true,
      }
    );
  });
});
