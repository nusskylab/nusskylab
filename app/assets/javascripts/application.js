//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-select
//= require jquery.tablesorter
//= require select2
//= require autosize
//= require thredded

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
    }).bind('sortEnd', function(e){
      if ($('.table-sortable>thead>tr>th.sort-index').length <= 0) {
        return ;
      }
      $('.table-sortable>tbody>tr').each(function (idx, val) {
        $($(val).children('td')[0]).html((idx + 1));
      });
    });
  }
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

/**
 * Form change detection and warning before unload
 */
$(function () {
  $('form.simple_form :input').change(function () {
    $('form.simple_form').data('form-changed', true);
  });
  $('form.simple_form input:submit').click(function (){
    $('form.simple_form').data('form-submitting', true);
  });
  window.addEventListener('beforeunload', function (e) {
    if (!$('form.simple_form').data('form-changed') || $('form.simple_form').data('form-submitting')) {
      $('form.simple_form').data('form-submitting', false);
      return undefined;
    }
    var confirmationMessage = 'You have unsaved changes. Are you sure want to navigate away?';

    (e || window.event).returnValue = confirmationMessage; //Gecko + IE
    return confirmationMessage; //Gecko + Webkit, Safari, Chrome etc.
  });
});

$(function () {
  $('*[data-remote=true]').each(function (idx, elem) {
    var remoteApi = $(elem).data('remote-api');
    var dataValues = $(elem).data('values');
    var callbackAction = $(elem).data('callback-action');
    $.ajax({
      type: 'GET',
      url: remoteApi,
      dataType: 'json'
    }).done(function (res) {
      if ($(elem).hasClass('question-multiple-select')) {
        $.each(res, function (idx, val) {
          if (dataValues.indexOf(val.id.toString()) != -1) {
            $(elem).append($('<option></option>', {value: val.id, text: val.content}).prop('selected', true));
          } else {
            $(elem).append($('<option></option>', {value: val.id, text: val.content}));
          }
        });
      }
      if (callbackAction === 'select2') {
        $(elem).select2({
          width: '100%'
        });
      }
    }).fail(function (err) {
      if (err.status != 200) {
        console.log(err);
      }
    });
  });
});
