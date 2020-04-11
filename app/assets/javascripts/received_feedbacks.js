'use strict';
$(document).ready(function () {
  disableAllFormInputs();

  function disableAllFormInputs() {
    $('input').attr('disabled', 'disabled');
    $('textarea').attr('disabled', 'disabled');
  }
});
