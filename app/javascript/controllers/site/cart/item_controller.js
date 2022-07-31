import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--cart--item"
export default class extends Controller {
  connect() {
    $('.touchspin-cart').TouchSpin();
    updateFeather();
  }

  removeItem() {
    const element = $(this.element);
    element.slideUp();
    element.remove();
    $('#navbar-cart-update-div').show();

    console.log("removed item");
  }
}
