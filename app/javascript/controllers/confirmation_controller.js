import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "confirmButton", "cancelButton"]

  connect() {
    this.confirmButtonTarget.addEventListener("click", this.handleConfirm.bind(this))
    this.cancelButtonTarget.addEventListener("click", this.handleCancel.bind(this))
  }

  disconnect() {
    this.confirmButtonTarget.removeEventListener("click", this.handleConfirm.bind(this))
    this.cancelButtonTarget.removeEventListener("click", this.handleCancel.bind(this))
  }

  confirm(event) {
    event.preventDefault()
    this.element.classList.remove("hidden")
  }

  handleConfirm() {
    const form = this.element.closest("form")
    if (form) {
      form.requestSubmit()
    }
  }

  handleCancel() {
    this.element.classList.add("hidden")
  }
} 