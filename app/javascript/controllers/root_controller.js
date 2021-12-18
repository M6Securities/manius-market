import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="root"
export default class extends Controller {
  connect() {
    console.log("test")
  }
}
