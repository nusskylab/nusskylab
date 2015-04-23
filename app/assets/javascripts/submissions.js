//= require validator
'use strict';
$(document).ready(function () {
  $('form[id^=edit_submission], form[id^=new_submission]').validator();

  function getParameterByName (name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }

  var milestone = getParameterByName('target');
  $('#user-submission-milestone option').filter(function () {
    return $(this).text().trim() === milestone;
  }).attr('selected', 'selected');
});
