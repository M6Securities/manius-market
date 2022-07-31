import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--cart--item"
export default class extends Controller {
  static targets = ["quantity"];


  connect() {
    $('.touchspin-cart').TouchSpin();
    updateFeather();

    this.quantityTarget.addEventListener('change', function (_event) {
      $('#navbar-cart-update-div').show();
    });
  }

  removeItem() {
    const element = $(this.element);
    element.slideUp();
    element.remove();
    $('#navbar-cart-update-div').show();

    console.log("removed item");
  }
}
