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
  order: [[ 0, 'asc' ]],
  drawCallback: function () {
    window.updateFeather();
  },
  dom: '<"card-header border-bottom p-1"<"head-label"><"dt-action-buttons text-right"B>><"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
  exportColumns: [0, 1]
}

/*
    This is the base class for all datatable controllers.

    mostly pulled from https://github.com/jgorman/stimulus-datatables/blob/master/src/index.js, but heavily modified

    The config that is sent must include the following:
    ajax: {
      url: datatableURL,
      type: 'GET'
    },
    columns: [
      { data: 'sku' },
      { data: 'name' },
      { data: 'stock' },
      {
        data: function (row, _type, _set) {
          return `<a href="${itemPath}/${row.id}" class="btn btn-outline-primary my-0 mr-0">
                          <i data-feather="chevrons-right"></i>
                        </a>`;
        }
      }
    ],
    columnDefs: [
      { name: 'sku',   targets: 0 },
      { name: 'name',  targets: 1 },
      { name: 'stock', targets: 2 },
      { name: 'view',  targets: 3, 'orderable': false, 'searchable': false },

      { targets: '_all', searchable: true, orderable: true}
    ],
    exportColumns: [0, 1, 2, 3],

    exportColumns are not part of the DataTable API, but are required for the export to work.
 */
export class StimulusDatatable extends Controller {
  static values = {
    url : String,
    itemPath: String,
    branchTable: String
  }

  // this will get overridden by the child controller
  config() {};

  initialize() {
    // console.log("Stimulus Datatable initialized");
  }

  connect() {
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
    return document.documentElement.hasAttribute('data-turbo-preview');
  }

  isLive() {
    return this.dataTable
  }

  isBooting() {
    return this.isTable() && !this.isDataTable() && !this.isPreview() && !this.isLive();
  }

  _teardown = () => this.teardown(this);

  teardown(_event) {
    if (!this.isLive()){
      return false;
    }

    document.removeEventListener('turbo:before-render', this._teardown);
    this.dataTable.destroy();
    this.dataTable = undefined;

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
