import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "bootstrap-datepicker"

$(document).ready(function () {
    $('.datepicker').datepicker({
        format: 'dd-mm-yyyy' // TODO: fix for time
    });
});

