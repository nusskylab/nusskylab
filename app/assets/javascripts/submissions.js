'use strict';
$(document).ready(function () {
  var milestone = getQueryParameterByName('target');
  $('#submission_milestone_id option').filter(function () {
    return $(this).text().trim() === milestone;
  }).attr('selected', 'selected');
});
