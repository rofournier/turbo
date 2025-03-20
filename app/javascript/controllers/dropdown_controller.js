import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]
  
  connect() {
    this.element.addEventListener("click", () => this.toggle())
    this.expanded = false
  }
  
  toggle() {
    this.expanded = !this.expanded
    this.listTarget.classList.toggle("hidden", !this.expanded)
  }

}
