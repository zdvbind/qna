// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
require("@nathanvda/cocoon")


Rails.start()
Turbolinks.start()
ActiveStorage.start()

// import "bootstrap"
import * as bootstrap from 'bootstrap'
import "../utilities/answers"
import "../utilities/edit_question"
import "../utilities/vote"
import "../stylesheets/application"


// document.addEventListener("turbolinks:load", ()=>{
//   $('[data-toggle="tooltip"]').tooltip();
//   $('[data-toggle="popover"]').popover()
// })

document.addEventListener('turbolinks:load', () => {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
})
