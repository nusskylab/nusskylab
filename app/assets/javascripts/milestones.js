//= require moment
// If you require timezone data (see moment-timezone-rails for additional file options)
//= require moment-timezone-with-data
//= require tempusdominus-bootstrap-4
'use strict';
$(function () {
  $('.datetime-picker').parent().css('position', 'relative');
  $('.datetime-picker').datetimepicker({format: 'YYYY-MM-DD LT'});
});

