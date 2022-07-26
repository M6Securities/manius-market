import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static targets = ['link']

  connect() {
    console.log("Theme controller connected");
  }

  toggleTheme() {
    const htmlElement = window.jQuery('html');

    console.log("toggleTheme");

    // check to see if htmlElement has the class 'dark-theme'
    if (htmlElement.hasClass('dark-layout')) {
      // remove the class 'dark-theme'
      htmlElement.removeClass('dark-layout');
      // add the class 'semi-dark-theme'
      htmlElement.addClass('semi-dark-layout');

      htmlElement.attr('data-layout', 'semi-dark-layout');

      this.linkTarget.innerHTML = '<i class="ficon" data-feather="moon"></i>';
      window.updateFeather();
    } else {
      // remove the class 'semi-dark-theme'
      htmlElement.removeClass('semi-dark-layout');
      // add the class 'dark-theme'
      htmlElement.addClass('dark-layout');

      // change attribute 'data-layout' to 'dark'
      htmlElement.attr('data-layout', 'dark-layout');

      // change the inner html to the moon icon
      this.linkTarget.innerHTML = '<i class="ficon" data-feather="sun"></i>';
      window.updateFeather();
    }
  }
}
