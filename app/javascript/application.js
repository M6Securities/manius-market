// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";

import jQuery from 'jquery';
import "bootstrap";
import "perfect-scrollbar";
import "classnames";

window.$ = jQuery;
window.jQuery = jQuery;

import "tether";
import "shepherd.js";
import "toastr";
import "wnumb";
import "nouislider";
import feather from 'feather-icons';
import Unison from "unison";


window.updateFeather = updateFeather;
window.validateEmail = validateEmail;
window.Unison = Unison;

import "controllers";

document.addEventListener('turbo:load', function () {
    updateFeather();
});

document.addEventListener('turbo:frame-render', function () {
    updateFeather();
});

document.addEventListener('turbo:render', function () {
    updateFeather();
});

window.jQuery(window).on('load', function () {
    updateFeather();
});

function updateFeather() {
    if (feather) {
        feather.replace({
            width: 14,
            height: 14
        });
    }
    return 'Updated Feather';
}

// https://stackoverflow.com/a/9204568
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}