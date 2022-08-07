import {StimulusDatatable} from "../../../datatable_controller";

// Connects to data-controller="app--user-space--order--index"
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
        {
          data: function (row, _type, _set) {
            const date = new Date(row.created_at);
            return date.toLocaleString();
          }
        },
        { data: 'count' },
        {
          data: function (row, _type, _set) {
            switch (row.status) {
              case 'not_acknowledged':
                return `<span class="badge badge-light-warning">Not Acknowledged</span>`;
              case 'acknowledged':
                return `<span class="badge badge-light-success">Acknowledged</span>`;
              case 'processing':
                return `<span class="badge bg-info">Processing</span>`;
              case 'shipped':
                return `<span class="badge badge-light-success">Shipped</span>`;
              case 'delivered':
                return `<span class="badge bg-success">Delivered</span>`;
              case 'cancelled':
                return `<span class="badge badge-light-danger">Cancelled</span>`;

              default:
                return '<span class="text-danger">Unknown</span>'
            }
          }
        },
        {
          data: function (row, _type, _set) {
            if (row.total_price === undefined) {
              return '<span class="badge badge-light-danger">Unknown</span>';
            } else {
              return `${row.total_price} ${row.total_price_currency}`;
            }
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
        { name: 'orders.created_at', targets: 0 },
        { name: 'count', targets: 1 },
        { name: 'orders.status', targets: 2 },
        { name: 'orders.total_price_cents', targets: 3 },
        { name: 'view',  targets: 4, 'orderable': false, 'searchable': false },

        { targets: '_all', searchable: true, orderable: true}
      ],
      exportColumns: [0, 1, 2]
    };
  }
}
