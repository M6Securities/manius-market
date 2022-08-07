import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="site--product--index"
export default class extends Controller {
  static targets = [ "productView" ];

  connect() {
  }

  productViewGrid() {
    this.productViewTarget.classList.add('grid-view');
    this.productViewTarget.classList.remove('list-view');
  }

  productViewList() {
    this.productViewTarget.classList.add('list-view');
    this.productViewTarget.classList.remove('grid-view');
  }
}
