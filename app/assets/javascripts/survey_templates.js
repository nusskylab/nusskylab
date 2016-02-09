//= require moment
//= require bootstrap-datetimepicker
'use strict';
$(function () {
  $('.datetime-picker').parent().css('position', 'relative');
  $('.datetime-picker').datetimepicker({format: 'YYYY-MM-DD LT'});
});
function disableViewTemplateInputs() {
  $('.view-question-template input').attr('disabled', true);
  $('.view-question-template textarea').attr('disabled', true);
}
$(function () {
  $('#new_question').on('ajax:success', function (e, data, status, xhr) {
    $(e.target).trigger('reset');
    disableViewTemplateInputs();
    $('#new-template-toggle').click();
    $('#survey-template-questions').append(data);
  }).on('ajax:error', function (e, data, status, xhr) {
    alert('Server error');
  });
});
$(function () {
  disableViewTemplateInputs();
  $('#survey-template-questions').on('ajax:success', '.edit_question', function (e, data, status, xhr) {
    $(e.target).parent().parent().html($(data).children());
    disableViewTemplateInputs();
  }).on('ajax:error', '.edit_question', function (e, data, status, xhr) {
    alert('Server error');
  });
});
$(function () {
  $('#survey-template-questions').on('click', '.toggle-view-edit-question-link', function (e) {
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
$(function () {
  $('#survey-template-questions').on('ajax:success', 'a.question-delete-link[data-remote]', function (e) {
    $(e.target).parent().parent().parent().remove();
  });
});
