'use strict';
$(document).ready(function () {
  var milestone = getQueryParameterByName('target');
  $('#submission_milestone_id option').filter(function () {
    return $(this).text().trim() === milestone;
  }).attr('selected', 'selected');

  function getQueryParameterByName (name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }
});

/**
 * Image uploading service via Imgur
 */
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
