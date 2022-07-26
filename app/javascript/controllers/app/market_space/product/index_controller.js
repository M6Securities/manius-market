import { Controller } from "@hotwired/stimulus"
import { StimulusDatatable } from "../../../datatable_controller";

// Connects to data-controller="app--market-space--product--index"
export default class extends StimulusDatatable {
  static values = {
    url : String,
    itemPath: String,
    branchTable: String
  }

  config() {
    const exportColumns = [0, 1, 2, 3];

    const datatableURL = this.urlValue;
    const itemPath = this.itemPathValue;

    return {
      ajax: {
        'url': datatableURL,
        'type': 'GET'
      },

      processing: true,
      serverSide: true,
      paging: true,
      pagingType: 'full_numbers',
      searching: true,
      lengthChange: true,
      responsive: true,
      order: [[ 0, 'desc' ]],
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
      drawCallback: function(_settings, _json) {
        updateFeather();
      },
      initComplete: function(_settings, _json) {
        const tableInput = $('div.dataTables_filter input');

        tableInput.unbind();
        tableInput.bind('keyup', function(e) {
          if(e.keyCode === 13) {
            branchTable.search(this.value).draw();
          }
        });
      },
      dom: '<"card-header border-bottom p-1"<"head-label"><"dt-action-buttons text-right"B>><"d-flex justify-content-between align-items-center mx-0 row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6"f>>t<"d-flex justify-content-between mx-0 row"<"col-sm-12 col-md-6"i><"col-sm-12 col-md-6"p>>',
      buttons: [
        {
          extend: 'csv',
          exportOptions: {
            columns: exportColumns
          }
        },
        {
          extend: 'copy',
          exportOptions: {
            columns: exportColumns
          }
        },
        {
          extend: 'pdf',
          exportOptions: {
            columns: exportColumns
          },
          orientation: 'landscape'
        },
        {
          extend: 'print',
          exportOptions: {
            columns: exportColumns
          }
        }
      ]
    };
  }
}
