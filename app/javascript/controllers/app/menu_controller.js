import { Controller } from "@hotwired/stimulus"

const discIconHTML = `<i data-feather="disc" class="feather d-none d-xl-block font-medium-4 text-primary"></i>`;
const circleIconHTML = `<i data-feather="circle" class="feather d-none d-xl-block font-medium-4 text-primary"></i>`;

// Connects to data-controller="app--menu"
export default class extends Controller {
  static targets = [ "toggle", "menu", "navbar" ];

  menuOpen = true;

  connect() {
    const that = this;


    $(this.toggleTarget).on('click', function (e) {
      that.toggleMenu(that);
    });

    $(this.menuTarget).on('mouseover', function(e) {
      that.hoverOverMenu(that);
    });

    $(this.menuTarget).on('mouseout', function(e) {
      that.hoverOutMenu(that);
    });

  }

  toggleMenu(that) {
    if (that.menuOpen) {
      that.closeMenu(that);
    } else {
      that.openMenu(that);
    }
  }

  closeMenu(that) {
    that.toggleTarget.innerHTML = circleIconHTML;
    window.updateFeather();

    const body = $('body');
    body.addClass('menu-collapsed');
    body.removeClass('menu-expanded');
    that.menuOpen = false;
  }

  openMenu(that) {
    that.toggleTarget.innerHTML = discIconHTML;
    window.updateFeather();

    const body = $('body');
    body.removeClass('menu-collapsed');
    body.addClass('menu-expanded');
    that.menuOpen = true;
  }

  hoverOverMenu(that) {
    $(this.element).addClass('expanded');
    return true;
  }

  hoverOutMenu(that) {
    $(this.element).removeClass('expanded');
    return true;
  }
}
