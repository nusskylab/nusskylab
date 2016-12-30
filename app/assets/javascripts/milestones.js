//= require moment
//= require bootstrap-datetimepicker
'use strict';
$(function () {
  $('.datetime-picker').parent().css('position', 'relative');
  $('.datetime-picker').datetimepicker({format: 'YYYY-MM-DD LT'});
});

