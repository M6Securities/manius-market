import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--checkout"
export default class extends Controller {

  connect() {
    $('.bootstrap-touchspin').TouchSpin();
    $('select:not(.flatpickr-input)').select2();

    const placeOrderButton = $('#place-order-button');
    const that = this;

    // this way it gets triggered if it's pre-filled
    if (this.validOrderForm()) {
      placeOrderButton.removeClass('disabled');
    } else {
      placeOrderButton.addClass('disabled');
    }

    $("#place-order-form input").change(function () {
      if (that.validOrderForm()) {
        placeOrderButton.removeClass('disabled');
      } else {
        placeOrderButton.addClass('disabled');
      }
    });
  }

  validOrderForm() {
    let valid = true;
    $("#place-order-form").find('input').each(function () {
      const element = $(this);
      if (element.prop('required')) {
        if (element.prop('type') === 'text') {
          if (element.val() === '') {
            valid = false;

            element.addClass('is-invalid');
            element.removeClass('is-valid');
          } else {
            element.removeClass('is-invalid');
            element.addClass('is-valid');
          }
        }
      }
    });

    const placeOrderEmail = $('#place-order-email');
    if (validateEmail(placeOrderEmail.val())) {
      placeOrderEmail.removeClass('is-invalid');
      placeOrderEmail.addClass('is-valid');
    } else {
      placeOrderEmail.addClass('is-invalid');
      placeOrderEmail.removeClass('is-valid');
      valid = false;
    }

    //console.log("Validating form: " + valid);

    return valid;
  }
}
