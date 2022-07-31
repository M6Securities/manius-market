import {StimulusDatatable} from "../../../datatable_controller";

// Connects to data-controller="app--market-space--product--orders"
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
            switch (row.payment_status) {
              case 'none':
                return '<span class="badge bg-danger">None</span>';
              case 'requires_payment_method':
                return '<span class="badge badge-light-warning">Requires Payment Method</span>';
              case 'requires_confirmation':
                return '<span class="badge badge-light-warning">Requires Confirmation</span>';
              case 'requires_action':
                return '<span class="badge bg-warning">Requires Action</span>';
              case 'processing':
                return '<span class="badge bg-info">Processing</span>';
              case 'requires_capture':
                return '<span class="badge bg-info">Requires Capture</span>';
              case 'cancelled':
                return '<span class="badge bg-danger">Canceled</span>';
              case 'succeeded':
                return '<span class="badge bg-success">Succeeded</span>';

              default:
                return '<span class="text-danger">Unknown</span>';
            }
          }
        },
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
            return `<a href="${itemPath}/${row.id}" class="btn btn-outline-primary my-0 mr-0">
                      <i data-feather="chevrons-right"></i>
                    </a>`;
          }
        }
      ],
      columnDefs: [
        { name: 'orders.created_at', targets: 0 },
        { name: 'count', targets: 1 },
        { name: 'orders.payment_status', targets: 2 },
        { name: 'orders.status', targets: 3 },
        { name: 'view',  targets: 4, 'orderable': false, 'searchable': false },

        { targets: '_all', searchable: true, orderable: true}
      ],
      exportColumns: [0, 1, 2, 3]
    }
  }
}
