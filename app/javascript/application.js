// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

window.updateFeather = updateFeather;
window.validateEmail = validateEmail;

document.addEventListener('turbo:load', function () {
    updateFeather();
});

document.addEventListener('turbo:frame-render', function () {
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