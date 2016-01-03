'use strict';
$(function () {
  $('#new_question').on('ajax:success', function (e, data, status, xhr) {
    console.log(data);
    alert(xhr.responseText);
  }).on('ajax:error', function (e, data, status, xhr) {
    console.log(data);
    alert(xhr.responseText);
  });
});
$(function () {
  $('.edit_question').on('ajax:success', function (e, data, status, xhr) {
    console.log(data);
    alert(xhr.responseText);
  }).on('ajax:error', function (e, data, status, xhr) {
    console.log(data);
    alert(xhr.responseText);
  });
});
$(function () {
  $('.toggle-view-edit-question-link').on('click', function (e) {
    var elem = $(e.target);
    var current = elem.html();
    if (current === 'Edit-question Form') {
      elem.html('View-question Form');
      elem.siblings('.view-question-template').hide();
      elem.siblings('.edit-question-template').show();
    } else {
      elem.html('Edit-question Form');
      elem.siblings('.view-question-template').show();
      elem.siblings('.edit-question-template').hide();
    }
  });
});
