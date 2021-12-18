import { Application } from "@hotwired/stimulus"

// also from https://github.com/arsley/stimulus-generator-rails

const application = Application.start()
const context = require.context("../javascripts/controllers", true, /\.js$/)

application.load(definitionsFromContext(context))

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
