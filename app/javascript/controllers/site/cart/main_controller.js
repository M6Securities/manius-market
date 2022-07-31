import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--cart--main"
export default class extends Controller {
  static values = { open : Boolean }

  connect() {
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
  }
}
