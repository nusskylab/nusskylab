'use strict';
$(function(){
  // filter button demo code
  $('button.filter').click(function(){
    var col = $(this).data('column'),
        txt = $(this).data('filter');
    $('table').find('.tablesorter-filter').val('').eq(col).val(txt);
    $('table').trigger('search', false);
    return false;
  });

  // toggle zebra widget
  $('button.zebra').click(function(){
    var t = $(this).hasClass('btn-success');
    $('table')
        .toggleClass('table-striped')[0]
        .config.widgets = (t) ? ["uitheme", "filter"] : ["uitheme", "filter", "zebra"];
    $(this)
        .toggleClass('btn-danger btn-success')
        .find('i')
        .toggleClass('icon-ok icon-remove glyphicon-ok glyphicon-remove').end()
        .find('span')
        .text(t ? 'disabled' : 'enabled');
    $('table').trigger('refreshWidgets', [false]);
    return false;
  });
});

$(document).ready(function () {
  $('#student_user_id').select2({
    width: '100%'
  });
  $('#students-table').tablesorter({
    theme : 'bootstrap',
    headerTemplate : '{content} {icon}'
  });
});
