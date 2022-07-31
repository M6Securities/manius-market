import {StimulusDatatable} from "../../../datatable_controller";

// Connects to data-controller="app--market-space--receiving--index"
export default class extends StimulusDatatable {
  config() {
    const datatableURL = this.urlValue;
    const itemPath = this.itemPathValue;

    return {
      ajax: {
        url: datatableURL,
        type: 'GET'
      },
      columns: [
        { data: 'created_at' },
        { data: 'user_id'},
        {
          data: function (row, _type, _set) {
            return `<a href="${itemPath}/${row.id}" class="btn btn-outline-primary my-0 mr-0">
                      <i data-feather="chevrons-right"></i>
                    </a>`;
          }
        }
      ],
      columnDefs: [
        { name: 'created_at', targets: 0 },
        { name: 'user_id', targets: 1 },
        { name: 'view', targets: 2, orderable: false, searchable: false },

        { targets: '_all', orderable: true, searchable: true}
      ],
      exportColumns: [0, 1]
    };
  }
}
