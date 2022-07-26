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
    const datatableURL = this.urlValue;
    const itemPath = this.itemPathValue;

    return {
      ajax: {
        'url': datatableURL,
        'type': 'GET'
      },
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
      exportColumns: [0, 1, 2, 3]
    };
  }
}
