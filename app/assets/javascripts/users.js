'use strict';
$(function () {
  function toggleDiabilityOfUid() {
    if ($('#user_provider').val() === '0') {
      $('#user_uid').attr('disabled', true);
    } else {
      $('#user_uid').attr('disabled', false);
    }
  }
  toggleDiabilityOfUid();
  $('#user_provider').on('change', function () {
    toggleDiabilityOfUid();
  });
});
