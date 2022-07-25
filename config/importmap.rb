# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin_all_from File.expand_path('../app/assets/javascripts', __dir__)
pin "datatables.net-autofill-bs5", to: "https://ga.jspm.io/npm:datatables.net-autofill-bs5@2.4.0/js/autoFill.bootstrap5.js"
pin "datatables.net", to: "https://ga.jspm.io/npm:datatables.net@1.12.1/js/jquery.dataTables.js"
pin "datatables.net-autofill", to: "https://ga.jspm.io/npm:datatables.net-autofill@2.4.0/js/dataTables.autoFill.js"
pin "datatables.net-bs5", to: "https://ga.jspm.io/npm:datatables.net-bs5@1.12.1/js/dataTables.bootstrap5.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js"
pin "datatables.net-buttons-bs5", to: "https://ga.jspm.io/npm:datatables.net-buttons-bs5@2.2.3/js/buttons.bootstrap5.js"
pin "datatables.net-colreorder-bs5", to: "https://ga.jspm.io/npm:datatables.net-colreorder-bs5@1.5.6/js/colReorder.bootstrap5.js"
pin "datatables.net-datetime", to: "https://ga.jspm.io/npm:datatables.net-datetime@1.1.2/dist/dataTables.dateTime.js"
pin "datatables.net-buttons", to: "https://ga.jspm.io/npm:datatables.net-buttons@2.2.2/js/dataTables.buttons.js"
pin "datatables.net-colreorder", to: "https://ga.jspm.io/npm:datatables.net-colreorder@1.5.6/js/dataTables.colReorder.js"
pin "datatables.net-fixedcolumns-bs5", to: "https://ga.jspm.io/npm:datatables.net-fixedcolumns-bs5@4.1.0/js/fixedColumns.bootstrap5.js"
pin "datatables.net-fixedheader-bs5", to: "https://ga.jspm.io/npm:datatables.net-fixedheader-bs5@3.2.4/js/fixedHeader.bootstrap5.js"
pin "datatables.net-keytable-bs5", to: "https://ga.jspm.io/npm:datatables.net-keytable-bs5@2.7.0/js/keyTable.bootstrap5.js"
pin "datatables.net-responsive-bs5", to: "https://ga.jspm.io/npm:datatables.net-responsive-bs5@2.3.0/js/responsive.bootstrap5.js"
pin "datatables.net-rowgroup-bs5", to: "https://ga.jspm.io/npm:datatables.net-rowgroup-bs5@1.2.0/js/rowGroup.bootstrap5.js"
pin "datatables.net-rowreorder-bs5", to: "https://ga.jspm.io/npm:datatables.net-rowreorder-bs5@1.2.8/js/rowReorder.bootstrap5.js"
pin "datatables.net-scroller-bs5", to: "https://ga.jspm.io/npm:datatables.net-scroller-bs5@2.0.7/js/scroller.bootstrap5.js"
pin "datatables.net-searchbuilder-bs5", to: "https://ga.jspm.io/npm:datatables.net-searchbuilder-bs5@1.3.4/js/searchBuilder.bootstrap5.js"
pin "datatables.net-searchpanes-bs5", to: "https://ga.jspm.io/npm:datatables.net-searchpanes-bs5@2.0.2/js/searchPanes.bootstrap5.js"
pin "datatables.net-select-bs5", to: "https://ga.jspm.io/npm:datatables.net-select-bs5@1.4.0/js/select.bootstrap5.js"
pin "datatables.net-staterestore-bs5", to: "https://ga.jspm.io/npm:datatables.net-staterestore-bs5@1.1.1/js/stateRestore.bootstrap5.js"
pin "stimulus-datatables", to: "https://ga.jspm.io/npm:stimulus-datatables@1.0.6/dist/index.js"
pin "datatables.net-fixedcolumns", to: "https://ga.jspm.io/npm:datatables.net-fixedcolumns@4.1.0/js/dataTables.fixedColumns.js"
pin "datatables.net-fixedheader", to: "https://ga.jspm.io/npm:datatables.net-fixedheader@3.2.4/js/dataTables.fixedHeader.js"
pin "datatables.net-keytable", to: "https://ga.jspm.io/npm:datatables.net-keytable@2.7.0/js/dataTables.keyTable.js"
pin "datatables.net-responsive", to: "https://ga.jspm.io/npm:datatables.net-responsive@2.3.0/js/dataTables.responsive.js"
pin "datatables.net-rowgroup", to: "https://ga.jspm.io/npm:datatables.net-rowgroup@1.2.0/js/dataTables.rowGroup.js"
pin "datatables.net-rowreorder", to: "https://ga.jspm.io/npm:datatables.net-rowreorder@1.2.8/js/dataTables.rowReorder.js"
pin "datatables.net-scroller", to: "https://ga.jspm.io/npm:datatables.net-scroller@2.0.7/js/dataTables.scroller.js"
pin "datatables.net-searchbuilder", to: "https://ga.jspm.io/npm:datatables.net-searchbuilder@1.3.4/js/dataTables.searchBuilder.js"
pin "datatables.net-searchpanes", to: "https://ga.jspm.io/npm:datatables.net-searchpanes@2.0.2/js/dataTables.searchPanes.js"
pin "datatables.net-select", to: "https://ga.jspm.io/npm:datatables.net-select@1.4.0/js/dataTables.select.js"
pin "datatables.net-staterestore", to: "https://ga.jspm.io/npm:datatables.net-staterestore@1.1.1/js/dataTables.stateRestore.js"
# pin "stimulus", to: "https://ga.jspm.io/npm:stimulus@1.1.1/dist/stimulus.umd.js"
