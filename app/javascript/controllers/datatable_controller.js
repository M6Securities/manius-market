import { Controller } from "@hotwired/stimulus";

const usualConfig = {
  processing: true,
  serverSide: true,
  paging: true,
  pagingType: 'full_numbers',
  searching: true,
  lengthChange: true,
  responsive: true,
  stateSave: true,
  fixedHeader: true,
  drawCallback: function () {
    window.updateFeather();
  },
  dom: '<"card-header border-bottom p-1"<"head-label"><"dt-action-buttons text-right"B>><"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
}

// mostly pulled from https://github.com/jgorman/stimulus-datatables/blob/master/src/index.js, but heavily modified
export class StimulusDatatable extends Controller {

  // this will get overridden by the child controller
  config() {};

  initialize() {
    // console.log("Stimulus Datatable initialized");
  }

  connect() {
    // console.log("Stimulus Datatable connected");
    // console.log(this.config());
    // console.log(this.element);

    // console.log("Is booting? " + this.isBooting());

    if (!this.isBooting()) return false

    // Register the teardown listener
    document.addEventListener('turbo:before-render', this._teardown)


    let config = usualConfig;
    // so you can overwrite default values
    Object.assign(config, this.config());

    const that = this;

    config.initComplete = function(_settings, _json) {
      const tableInput = $('div.dataTables_filter input');

      tableInput.unbind();
      tableInput.bind('keyup', function(e) {
        if(e.keyCode === 13) {
          that.dataTable.search(this.value).draw();
        }
      });
    };

    config.buttons = [
      {
        extend: 'csv',
        exportOptions: {
          columns: config.exportColumns
        }
      },
      {
        extend: 'copy',
        exportOptions: {
          columns: config.exportColumns
        }
      },
      {
        extend: 'pdf',
        exportOptions: {
          columns: config.exportColumns
        },
        orientation: 'landscape'
      },
      {
        extend: 'print',
        exportOptions: {
          columns: config.exportColumns
        }
      }
    ];

    // console.log(config);

    this.dataTable = window.jQuery(this.element).DataTable(config);
  }

  isTable() {
    return this.element.tagName === 'TABLE';
  }

  isDataTable() {
    return this.element.className.includes('dataTable');
  }

  isPreview() {
    return document.documentElement.hasAttribute('data-turbolinks-preview');
  }

  isLive() {
    return this.dataTable
  }

  isBooting() {
    return this.isTable() && !this.isDataTable() && !this.isPreview() && !this.isLive();
  }

  _teardown = () => this.teardown(this);

  teardown(_event) {
    // console.log("Teardown event");

    if (!this.isLive()){
      return false;
    }

    document.removeEventListener('turbo:before-render', this._teardown);
    this.dataTable.destroy();
    this.dataTable = undefined;

    // this.debug('teardown')
    return true;
  }

}

// Connects to data-controller="datatable"
export default class Datatable extends StimulusDatatable {
  static get shouldLoad() {
    return false;
  }

  connect() {
    // console.log("Datatable connected");
  }
}
