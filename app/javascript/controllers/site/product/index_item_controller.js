import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--product--index-item"
export default class extends Controller {
  static values = {
    id: String
  };

  addItem() {
    console.log('adding to cart');
    const id = `add-to-cart-form-${this.idValue}`;

    const formElement = document.getElementById(id);
    const url = '/en/cart/update_item';
    const form = new FormData(formElement);

    const postForm = $.ajax({
      url: url,
      data: form,
      cache: false,
      processData: false,
      contentType: false,
      type: 'POST',
      success: function (data) {
        //console.log(data)
        // document.getElementById('customer_<%= @current_customer.id %>').src = '<%= cart_navbar_path %>';
        // document.getElementById('customer_<%= @current_customer.id %>').reload();
      }
    });
  }
}
