//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require select2

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
    });
  }
});

$(function () {
  function convertImageToBase64Str(imgInput) {
    if (imgInput.files && imgInput.files[0]) {
      var fileReader = new FileReader();
      return fileReader.readAsDataURL(imgInput.files[0]);
    } else {
      return null;
    }
  }
  $('input.imgur-upload').change(function () {
    var convertedStr = convertImageToBase64Str(this);
    $(this).prop('data-base64str', convertedStr);
  });
});
