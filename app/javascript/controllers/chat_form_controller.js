import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "form"]

  submitStart() {
    this.submitTarget.disabled = true
    this.submitTarget.innerText = "Sending..."
    this.submitTarget.classList.add("opacity-50", "cursor-not-allowed")
  }

  submitEnd(event) {
    if (this.hasFormTarget) {
      this.formTarget.reset()
    }

    this.submitTarget.disabled = false
    this.submitTarget.innerText = "Send"
    this.submitTarget.classList.remove("opacity-50", "cursor-not-allowed")
  }
}
