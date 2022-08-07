import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--cart--main"
export default class extends Controller {
  static values = { open : Boolean };
  static targets = ['form'];

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


    const updateButtonDiv = $('#navbar-cart-update-div');
    const updateButton = $('#navbar-cart-update');

    /*
    this.formTarget.addEventListener('turbo:submit-start', (event) => {
      updateButton.prepend('<span class="spinner-border spinner-border-sm text-success"></span>');
      updateButton.addClass('disabled');
    });

    this.formTarget.addEventListener('turbo:submit-end', (event) => {
      updateButtonDiv.hide();
      updateButton.removeClass('disabled');
      updateButton.children('.spinner-border').remove();
    });
     */

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

  async formSubmit(event) {
    event.preventDefault();

    const updateButtonDiv = $('#navbar-cart-update-div');
    const updateButton = $('#navbar-cart-update');
    const formElement = $(event.target);

    updateButton.prepend('<span class="spinner-border spinner-border-sm text-success"></span>');
    updateButton.addClass('disabled');

    // continue event
    event.target.submit();

    updateButtonDiv.hide();
    updateButton.removeClass('disabled');
    updateButton.children('.spinner-border').remove();


    // updateButtonDiv.hide();
  }
}
