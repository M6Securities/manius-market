import { Controller } from "@hotwired/stimulus"

// mostly pulled from https://github.com/jgorman/stimulus-datatables/blob/master/src/index.js
export class StimulusDatatable extends Controller {

  initialize() {
    // console.log("Stimulus Datatable initialized");
  }

  connect() {
    // console.log("Stimulus Datatable connected");
    // console.log(this.config());
    // console.log(this.element);

    // console.log("Is booting? " + this.isBooting());

    if (!this.isBooting()) return false

    // Register the teardown listener and start up DataTable.
    document.addEventListener('turbo:before-render', this._teardown)
    this.dataTable = window.jQuery(this.element).DataTable(this.config());
  }

  config() {};

  isTable() {
    return this.element.tagName === 'TABLE';
  }

  isDataTable() {
    return this.element.className.includes('dataTable');
  }

  isPreview() {
    return document.documentElement.hasAttribute('data-turbolinks-preview');
  }

  isLive() {
    return this.dataTable
  }

  isBooting() {
    return this.isTable() && !this.isDataTable() && !this.isPreview() && !this.isLive();
  }

  _teardown = () => this.teardown(this);

  teardown(_event) {
    // console.log("Teardown event");

    if (!this.isLive()){
      return false
    }

    document.removeEventListener('turbo:before-render', this._teardown)
    this.dataTable.destroy()
    this.dataTable = undefined

    // this.debug('teardown')
    return true
  }

}

// Connects to data-controller="datatable"
export default class Datatable extends StimulusDatatable {
  static get shouldLoad() {
    return false
  }

  connect() {
    // console.log("Datatable connected");
  }
}
