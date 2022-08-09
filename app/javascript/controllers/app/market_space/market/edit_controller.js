import { Controller } from "@hotwired/stimulus"

const gatewayConfig = {
  stripe: ['publishable_key', 'secret_key']
}

// Connects to data-controller="app--market-space--market--edit"
export default class extends Controller {
  static targets = [ "gatewayTable", "gatewaySelect" ];

  addGateway() {
    const gatewaySelect = $(this.gatewaySelectTarget);
    const selectedGateway = gatewaySelect.val();

    console.log(selectedGateway);

    if (selectedGateway === "") {
        return;
    }

    // get display text from select option using val()
    const gatewayText = gatewaySelect.find("option:selected").text();

    // remove selected option from select
    gatewaySelect.find("option:selected").remove();

    // generate credentials html
    let credentialsHtml = `<div class="d-flex">`;
    for (const key of gatewayConfig[selectedGateway]) {
        credentialsHtml += `<input type="text" class="form-control me-1" name="update[payment_gateways][]${selectedGateway}[${key}]" placeholder="${key}" required>`;
    }
    credentialsHtml += `</div>`;

    // add gateway to table
    const gatewayTable = $(this.gatewayTableTarget);
    const html = `
        <tr>
            <td>
             <input type="text" class="form-control" name="update[payment_gateways][][name]" value="${gatewayText}" readonly>
             <input type="hidden" name="update[payment_gateways][][gateway]" value="${selectedGateway}" readonly>
            </td>
            <td>
              Not Saved
            </td>
            <td>
              ${credentialsHtml}
            </td>
            <td>
                <button type="button" class="btn btn-danger" data-action="app--market-space--market--edit#removeGateway">
                    <i data-feather="trash"></i>
                </button>
            </td>
        </tr>
    `;
    gatewayTable.append(html);
    window.updateFeather();
  }

  removeGateway(event) {
    let element = $(event.target);

    while (element.prop("tagName") !== "TR") {
      element = element.parent();
    }

    element.remove();
  }
}
