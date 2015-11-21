//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.tablesorter
//= require select2
//= require jQuery.autolink
//= require autosize

/**
 * Customization for table sorter
 */
$(function () {
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
    }).bind("sortEnd", function(e){
      if ($('.table-sortable>thead>tr>th.sort-index').length <= 0) {
        return ;
      }
      $('.table-sortable>tbody>tr').each(function (idx, val) {
        $($(val).children('td')[0]).html((idx + 1));
      });
    });;
  }
});

/**
 * Autolink links. Mainly for video links. 
 */
$(function() {
  $('.autolink').autolink();
});

/**
 * Autosize textareas. TinyMCE are autosized by its own plugin.
 */
$(function() {
  autosize($('textarea:not(.tinymce)'));
});

/**
 * Back to top widget.
 */
$(window).scroll(function() {
  if ($(this).scrollTop() >= 100) {
    $('#return-to-top').fadeIn(200);
  } else {
    $('#return-to-top').fadeOut(200);
  }
});
$('#return-to-top').click(function() {
  $('body,html').animate({
    scrollTop : 0
  }, 500);
});
