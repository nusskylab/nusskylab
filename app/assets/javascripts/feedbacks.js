'use strict';
$(document).ready(function () {
  $('input[name="feedback[feedback_to_team]"]').change(function (e) {
    if ($(e.target).prop('checked')) {
      $('#target_type_teams').show();
      $('#target_type_advisers').hide();
    } else {
      $('#target_type_teams').hide();
      $('#target_type_advisers').show();
    }
  });
});
