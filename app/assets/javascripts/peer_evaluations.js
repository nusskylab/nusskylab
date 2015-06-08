'use strict';
$(document).ready(function () {
  var currentPageHeading = $('#main-content > div > div.panel-heading > h3').html();
  if (currentPageHeading === 'Edit peer evaluation') {
    fillInPublicPartOfHtmlForm();
    fillInPrivatePartOfHtmlForm();
  } else if (currentPageHeading === 'View peer evaluation') {
    fillInPublicPartOfHtmlForm();
    if ($('#peer-evaluation-private-content').length) {
      fillInPrivatePartOfHtmlForm();
    }
    disableAllEvalFormInputs();
  } else if (currentPageHeading === 'Create peer evaluation') {
    setSubmissionForEval();
  }

  $('.new_peer_evaluation').on('submit', function () {
    $('#peer-evaluation-public-content').val(getPublicPartValues());
    $('#peer-evaluation-private-content').val(getPrivatePartValues());
    return validateEvalTemplate();
  });

  $('.edit_peer_evaluation').on('submit', function () {
    $('#peer-evaluation-public-content').val(getPublicPartValues());
    $('#peer-evaluation-private-content').val(getPrivatePartValues());
    return validateEvalTemplate();
  });

  function validateEvalTemplate() {
    var values = {};
    var isValid = true;
    $('.eval-has-error').removeClass('eval-has-error');
    $('#eval-template input[type=radio]:checked').each(function (idx, val) {
      values[$(val).attr('name')] = $(val).attr('value');
    });
    $('#eval-template input[type=radio]').each(function (idx, val) {
      if (!(values[$(val).attr('name')])) {
        isValid = false;
        $(val).parent().addClass('eval-has-error');
        $('#eval-template-error').html('The evaluation contains error(s). Please fill in required fields, with enough feedback and submit again');
        $('#eval-template-error').show();
      }
    });
    $('#eval-template textarea[required=required]').each(function (idx, val) {
      if ($(val).val().length < 30) {
        $(val).addClass('eval-has-error');
        isValid = false;
        $('#eval-template-error').html('The evaluation contains error(s). Please fill in required fields, with enough feedback and submit again');
        $('#eval-template-error').show();
      }
    });
    return isValid;
  }

  function setSubmissionForEval() {
    var submission_id = getQueryParameterByName('target');
    $('#peer_evaluation_submission_id option').filter(function () {
      return $(this).val() === submission_id;
    }).attr('selected', 'selected');
  }

  function getPublicPartValues() {
    var values = {};
    $('#eval-public input[type=radio]:checked').each(function (idx, val) {
      values[$(val).attr('name')] = $(val).attr('value');
    });
    $('#eval-public textarea').each(function (idx, val) {
      values[$(val).attr('name')] = $(val).val();
    });
    return JSON.stringify(values);
  }

  function getPrivatePartValues() {
    var values = {};
    $('#eval-private input[type=radio]:checked').each(function (idx, val) {
      values[$(val).attr('name')] = $(val).attr('value');
    });
    $('#eval-private textarea').each(function (idx, val) {
      values[$(val).attr('name')] = $(val).val();
    });
    return JSON.stringify(values);
  }

  function fillInPublicPartOfHtmlForm() {
    try {
      var publicValues = JSON.parse($('#peer-evaluation-public-content').val());
      $.each(publicValues, function (attrName, attrVal) {
        if (attrVal && !isNaN(parseInt(attrVal))
            && parseInt(attrVal) >= 0 && attrVal.match(/^[0-9]+$/)) {
          $('#eval-public input[type=radio][name="' +
          attrName + '"][value="' + attrVal + '"]').attr('checked', 'checked');
        }
        $('#eval-public textarea[name="' + attrName + '"]').val(attrVal);
      });
    } catch (err) {
      console.log(err.message);
    }
  }

  function fillInPrivatePartOfHtmlForm() {
    try {
      var privateValues = JSON.parse($('#peer-evaluation-private-content').val());
      $.each(privateValues, function (attrName, attrVal) {
        if (attrVal && !isNaN(parseInt(attrVal))
            && parseInt(attrVal) >= 0 && attrVal.match(/^[0-9]+$/)) {
          $('#eval-private input[type=radio][name="' +
          attrName + '"][value="' + attrVal + '"]').attr('checked', 'checked');
        }
        $('#eval-private textarea[name="' + attrName + '"]').val(attrVal);
      });
    } catch (err) {
      console.log(err.message);
    }
  }

  function disableAllEvalFormInputs() {
    $('input').attr('disabled', 'disabled');
    $('textarea').attr('disabled', 'disabled');
  }

  function getQueryParameterByName (name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }
});
