// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function updateFeather() {
    if (feather) {
        feather.replace({
            width: 14,
            height: 14
        });
    }
    return 'Updated Feather';
}

window.updateFeather = updateFeather;

document.addEventListener('turbo:load', function () {
    updateFeather();
});

document.addEventListener('turbo:frame-render', function () {
    updateFeather();
});

window.jQuery(window).on('load', function () {
    updateFeather();
});