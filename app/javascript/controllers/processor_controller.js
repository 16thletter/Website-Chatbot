import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["webForm", "documentForm", "webButton", "documentButton"]

  connect() {
    this.selectWeb() // default selection
  }

  selectWeb() {
    this.webFormTarget.classList.remove("hidden")
    this.documentFormTarget.classList.add("hidden")
    this.webButtonTarget.dataset.selected = "true"
    this.documentButtonTarget.dataset.selected = "false"
  }

  selectDocument() {
    this.webFormTarget.classList.add("hidden")
    this.documentFormTarget.classList.remove("hidden")
    this.webButtonTarget.dataset.selected = "false"
    this.documentButtonTarget.dataset.selected = "true"
  }
}
