import {StimulusDatatable} from "../../../datatable_controller";

// Connects to data-controller="app--market-space--user--index"
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
        { data: 'display_name' },
        { data: 'email' },
        {
          data: function (row, _type, _set) {
            const date = new Date(row.last_activity_at);
            return date.toLocaleString();
          }
        },
        {
          data: function (row, _type, _set) {
            return `<a href="${itemPath}/${row.id}" class="btn btn-outline-primary my-0 mr-0">
                      <i data-feather="chevrons-right"></i>
                    </a>`;
          }
        }
      ],
      columnDefs: [
        { name: 'display_name', targets: 0 },
        { name: 'email',    targets: 1 },
        { name: 'last_activity_at', targets: 2 },
        { name: 'view',         targets: 3, orderable: false, searchable: false },

        { targets: '_all', searchable: true, orderable: true}
      ],
      exportColumns: [0, 1, 2]
    }

  }
}
