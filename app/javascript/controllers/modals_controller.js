import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {
    document.addEventListener("modal-close", this.closeModal.bind(this));
  }

  disconnect() {
    document.removeEventListener("modal-close", this.closeModal.bind(this));
  }

  close(e) {
    e.preventDefault();

    const modal = document.getElementById("modal");
    modal.innerHTML = "";
    modal.removeAttribute("src");
    modal.removeAttribute("complete");
  }

  closeModal() {
    this.close(new Event("close"));
  }
}
