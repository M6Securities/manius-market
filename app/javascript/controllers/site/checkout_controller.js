import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--checkout"
export default class extends Controller {
  static values = {
    url: String,
    key: String
  }

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

  checkoutFormSubmit(event) {
    event.preventDefault();

    const stripeURL = this.urlValue;
    const stripeKey = this.keyValue;

    if (!this.validOrderForm()) {
      return null;
    }

    const stripe = Stripe(stripeKey);

    const formElement = document.getElementById('place-order-form');
    const formData = new FormData(formElement);

    console.log(formData);

    // Create a new Checkout Session using the server-side endpoint you
    // created in step 3.
    fetch(stripeURL, {
      method: 'POST',
      body: formData
    })
        .then(function (response) {
          return response.json();
        })
        .then(function (session) {
          console.log(session)

          return stripe.redirectToCheckout({
            sessionId: session.id
          });

        })
        .then(function (result) {
          console.log(result)
          // If `redirectToCheckout` fails due to a browser or network
          // error, you should display the localized error message to your
          // customer using `error.message`.
          if (result.error) {
            alert(result.error.message);
          }
        })
        .catch(function (error) {
          console.error('Error:', error);
        });
  }
}
