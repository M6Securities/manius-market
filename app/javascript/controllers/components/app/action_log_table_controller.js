import {StimulusDatatable} from "../../datatable_controller";

// Connects to data-controller="components--app--action-log-table"
export default class extends StimulusDatatable {
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
        {
          data: function (row, _type, _set) {
            const date = new Date(row.created_at);
            return date.toLocaleString();
          }
        },
        { data: 'action' },
        {
          data: function (row, _type, _set) {
            return `<a href="${itemPath}/${row.id}" class="btn btn-outline-primary my-0 mr-0" data-turbo-frame="_top">
                      <i data-feather="user"></i>
                    </a>`;
          }
        }
      ],
      columnDefs: [
        { name: 'created_at', targets: 0 },
        { name: 'action', targets: 1, orderable: false, searchable: false },
        { name: 'user',  targets: 2, orderable: false, searchable: false },

        { targets: '_all', searchable: true, orderable: true}
      ],
      exportColumns: [0, 1, 2]
    }
  }
}
