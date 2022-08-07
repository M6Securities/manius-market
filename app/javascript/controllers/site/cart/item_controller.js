import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--cart--item"
export default class extends Controller {
  static targets = ["quantity"];


  connect() {
    $('.touchspin-cart').TouchSpin();
    updateFeather();

    const that = this;

    this.quantityTarget.addEventListener('change', function (event) {
      that.changeEvent(event);
    });

    $('.cart-item-qty button.bootstrap-touchspin-up').on('click', function (event) {
      that.changeEvent(event);
    });

    $('.cart-item-qty button.bootstrap-touchspin-down').on('click', function (event) {
      that.changeEvent(event);
    });

    document.addEventListener('turbo:before-stream-render', function (event) {
      that.updateCartCount();
      $('#navbar-cart-update-div').hide();
    });

    this.updateCartCount();
  }

  removeItem() {
    const element = $(this.element);
    element.slideUp();
    element.remove();
    $('#navbar-cart-update-div').show();
  }

  changeEvent(_event) {
    $('#navbar-cart-update-div').show();
    this.updateCartCount();
  }

  updateCartCount() {
    // calculate the number of items in the cart, and update the navbar
    const itemInputs = $('.cart-navbar-input');
    let numItems = 0;
    // for every element in itemInputs, add the value to numItems
    itemInputs.each(function () {
      const value = parseInt($(this).val());

      //if value is not NaN, add it to numItems
      if (isNaN(value)) {
          numItems += 0;
      } else {
          numItems += value;
      }
    });

    let itemCountElements = $('.cart-item-count');
    const cartTotal = $('#cart-total-price').val();

    // console.log(numItems);
     // console.log(cartTotal);

    // if it exists
    // remember itemCountElements has two entries. One on the navbar, one on the cart page.
    if (itemCountElements.length > 1) {
      itemCountElements.text(numItems);
    } else {
      // if it doesn't exist, create it
      $('#cart-navbar-dropdown-button').append(`<span class="badge rounded-pill bg-primary badge-up cart-item-count">${numItems}</span>`);
      itemCountElements = $('.cart-item-count');
    }

    if(numItems === 0) {
      // $('#navbar-cart-update-div').hide();
    }

    $('#cart-total-price-display').text(cartTotal);
  }
}
