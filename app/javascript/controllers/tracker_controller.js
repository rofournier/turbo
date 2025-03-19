import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {

  connect() {
    // Use event delegation on document to catch form submissions
    console.log("Tracker controller connected")
  }

}
