import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="app--market-space--receiving--edit"
export default class extends Controller {
  connect() {
    $('.touchspin-cart').TouchSpin();
  }
}
