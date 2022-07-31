# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin_all_from File.expand_path('../app/assets/javascripts', __dir__)

# vendor js
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js', preload: true
pin 'perfect-scrollbar', to: 'https://ga.jspm.io/npm:perfect-scrollbar@1.5.5/dist/perfect-scrollbar.esm.js', preload: true
pin 'classnames', to: 'https://ga.jspm.io/npm:classnames@2.3.1/index.js', preload: true
pin 'bootstrap', to: 'https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.bundle.min.js', preload: true
pin '@popperjs/core', to: 'https://ga.jspm.io/npm:@popperjs/core@2.11.5/lib/index.js', preload: true

pin 'app-menu', to: 'https://cdn.m6securities.com/vuexy_admin_8-0/app-assets/js/core/app-menu.min.js', preload: true
pin 'app', to: 'https://cdn.m6securities.com/vuexy_admin_8-0/app-assets/js/core/app.min.js', preload: true
pin 'customizer', to: 'https://cdn.m6securities.com/vuexy_admin_8-0/app-assets/js/scripts/customizer.min.js', preload: true

pin 'polyfill', to: 'https://ga.jspm.io/npm:polyfill@0.1.0/index.js'
pin 'sweetalert', to: 'https://ga.jspm.io/npm:sweetalert@2.1.2/dist/sweetalert.min.js'
pin 'sweetalert-extensions', to: 'https://cdn.m6securities.com/vuexy_admin_8-0/app-assets/js/scripts/extensions/ext-component-sweet-alerts.js'

pin 'tether', to: 'https://ga.jspm.io/npm:tether@2.0.0/dist/js/tether.js'
pin 'shepherd.js', to: 'https://ga.jspm.io/npm:shepherd.js@10.0.0/dist/js/shepherd.esm.js'
pin 'toastr', to: 'https://ga.jspm.io/npm:toastr@2.1.4/toastr.js'
pin 'wnumb', to: 'https://ga.jspm.io/npm:wnumb@1.2.0/wNumb.js'
pin 'nouislider', to: 'https://ga.jspm.io/npm:nouislider@15.6.0/dist/nouislider.js'
pin 'feather-icons', to: 'https://ga.jspm.io/npm:feather-icons@4.29.0/dist/feather.js'
pin 'unison'

pin 'app-ecommerce', to: 'https://cdn.m6securities.com/vuexy_admin_8-0/app-assets/js/scripts/pages/app-ecommerce.min.js'
pin 'jquerySticky', to: 'https://cdn.m6securities.com/vuexy_admin_8-0/app-assets/vendors/js/ui/jquery.sticky.js'
