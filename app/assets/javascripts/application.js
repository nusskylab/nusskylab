//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.tablesorter
//= require select2
//= require jQuery.autolink
//= require autosize

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
  if ($('.table-sortable:not(.uncountable)').length) {
    var numberOfRows = $('.table-sortable tbody tr').length;
    $('<div></div>').html('Number of rows: ' + numberOfRows)
        .addClass('alert alert-info').insertBefore($('.table-sortable'));
  }
});

$(function () {
  $('input.imgur-upload').change(function () {
    var imageInput = $(this);

    function setDataAttributeOfImageInput(dataStr) {
      var imgStr = dataStr.substring(dataStr.search(';base64,') + 8);
      var imgFeedback = imageInput.siblings('.imgur-feedback');
      $.ajax({
        type: 'POST',
        beforeSend: function (req) {
          req.setRequestHeader('Authorization', 'Client-ID 47c72725b2642de');
          imgFeedback.html('Waiting for response');
          imgFeedback.removeClass('alert alert-danger alert-success');
          imgFeedback.addClass('alert alert-info');
        },
        url: 'https://api.imgur.com/3/upload',
        data: {
          image: imgStr
        },
        success: function (res) {
          if (res.data && res.data.link) {
            imgFeedback.html('The uploaded image link: ' + res.data.link);
            imgFeedback.removeClass('alert alert-info alert-danger');
            imgFeedback.addClass('alert alert-success');
          } else {
            imgFeedback.html('Some error happened while uploading the image, please try again');
            imgFeedback.removeClass('alert alert-info alert-success');
            imgFeedback.addClass('alert alert-danger');
          }
        },
        error: function (err) {
          console.log(err);
          imgFeedback.html('Some error happened while uploading the image, please try again');
          imgFeedback.removeClass('alert alert-info alert-success');
          imgFeedback.addClass('alert alert-danger');
        }
      });
    }

    function convertImageToBase64Str(imgInput) {
      if (imgInput.files && imgInput.files[0]) {
        var fileReader = new FileReader();
        fileReader.readAsDataURL(imgInput.files[0]);
        fileReader.onload = function () {
          setDataAttributeOfImageInput(this.result);
        };
      }
    }

    convertImageToBase64Str(this);
  });
});

$(function() {
  $('.autolink').autolink();
});

$(function() {
  autosize($('textarea:not(.tinymce)'));
});

$(window).scroll(function() {
  if ($(this).scrollTop() >= 50) {
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
