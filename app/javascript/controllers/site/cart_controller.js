import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--cart"
export default class extends Controller {
  static values = { open : Boolean }

  initialize() {
    // console.log(this.openValue);
  }


  connect() {
    // console.log("Cart controller connected");

    $('.touchspin-cart').TouchSpin();


    // let open = <%= @show_navbar_cart ? 'true' : 'false' %>;
    let open = true;

    // Prevents menu from closing when clicked inside
    document.getElementById('cart-navbar-dropdown-items').addEventListener('click', function (event) {
      event.stopPropagation();
    });

    $('.cart-navbar-input').change(function() {
      //cartNavbar.update();
      $('#navbar-cart-update-div').show();
    });
  }

  toggleDropdown() {
    console.log("toggleDropdown");

    const cardNavbarDropdownButton = $('#cart-navbar-dropdown-button');
    if (this.openValue) {
      cardNavbarDropdownButton.removeClass('show');
      cardNavbarDropdownButton.attr('aria-expanded', 'false');
      $('#cart-navbar-dropdown-items').removeClass('show');
      this.openValue = false;
    } else {
      cardNavbarDropdownButton.addClass('show');
      cardNavbarDropdownButton.attr('aria-expanded', 'true');
      $('#cart-navbar-dropdown-items').addClass('show');
      this.openValue = true;
    }

    console.log(this.openValue);
  }

  removeItem(event) {
    const element = $(`#cart-item-div-${event.params.item}`);
    element.slideUp();
    element.remove();
    $('#navbar-cart-update-div').show();

    console.log("removed item");
  }
}
