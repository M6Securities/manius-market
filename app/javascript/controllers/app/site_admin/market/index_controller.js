import {StimulusDatatable} from "../../../datatable_controller";

// Connects to data-controller="app--site-admin--market--index"
export default class extends StimulusDatatable {
  config() {
    const datatableURL = this.urlValue;
    const itemPath = this.itemPathValue;

    return {
      ajax: {
        url: datatableURL,
        type: 'GET'
      },
      order: [[ 2, 'asc' ]],
      columns: [
        { data: 'display_name' },
        { data: 'path_name' },
        {
          data: function (row, _type, _set) {
            const date = new Date(row.created_at);
            return date.toLocaleString();
          }
        },
        {
          data: function (row, _type, _set) {
            return `<a href="" class="btn btn-outline-primary my-0 mr-0">
                      <i data-feather="chevrons-right"></i>
                    </a>`;
          }
        }
      ],
      columnDefs: [
        { name: 'display_name', targets: 0 },
        { name: 'path_name',    targets: 1 },
        { name: 'created_at',   targets: 2 },
        { name: 'view',         targets: 3, 'orderable': false, 'searchable': false },

        { targets: '_all', searchable: true, orderable: true}
      ],
      exportColumns: [0, 1, 2]
    }
  }
}
