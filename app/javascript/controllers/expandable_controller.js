import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "expandIcon", "collapseIcon"]
  
  connect() {
    console.log("Hello, expandable!")
    this.expanded = false
    this.expandIconTarget.addEventListener("click", () => this.toggle())
    this.collapseIconTarget.addEventListener("click", () => this.toggle())
  }
  
  toggle() {
    if (this.expanded) {
      this.collapse()
    } else {
      this.expand()
    }
    
    this.expanded = !this.expanded
  }
  
  expand() {
    this.containerTarget.classList.add("fixed", "inset-4", "z-50", "max-w-none")
    this.expandIconTarget.classList.add("hidden")
    this.collapseIconTarget.classList.remove("hidden")
  }
  
  collapse() {
    this.containerTarget.classList.remove("fixed", "inset-4", "z-50", "max-w-none")
    this.expandIconTarget.classList.remove("hidden")
    this.collapseIconTarget.classList.add("hidden")
  }
}
