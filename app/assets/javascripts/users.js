'use strict';
$(function(){
  if ($('.table-sortable').length) {
    $('.table-sortable').tablesorter({
      theme : 'bootstrap',
      widthFixed: true,
      headerTemplate : '{content} {icon}',
      widgets : [ 'uitheme' ],
      headers: {
        '.unsortable' : {
          sorter: false
        }
      }
    })
  }
});
