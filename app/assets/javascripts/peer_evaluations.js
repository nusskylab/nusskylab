'use strict';
$(document).ready(function () {
  if ($('#main-content > div > div.panel-heading > h3').html() === 'Edit peer evaluation') {
    fillInPublicPartOfHtmlForm();
    fillInPrivatePartOfHtmlForm();
  } else if ($('#main-content > div > div.panel-heading > h3').html() === 'View peer evaluation') {
    fillInPublicPartOfHtmlForm();
    if ($('#peer-evaluation-private-content').length) {
      fillInPrivatePartOfHtmlForm();
    }
    disableAllEvalFormInputs();
  }

  $('.new_peer_evaluation').on('submit', function () {
    $('#peer-evaluation-public-content').val(getPublicPartValues());
    $('#peer-evaluation-private-content').val(getPrivatePartValues());
  });

  $('.edit_peer_evaluation').on('submit', function () {
    $('#peer-evaluation-public-content').val(getPublicPartValues());
    $('#peer-evaluation-private-content').val(getPrivatePartValues());
  });

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
    var publicValues = JSON.parse($('#peer-evaluation-public-content').val());
    $.each(publicValues, function (attrName, attrVal) {
      $('#eval-public input[type=radio][name="' + attrName + '"][value="' + attrVal + '"]').attr('checked', 'checked');
      $('#eval-public textarea[name="' + attrName + '"]').val(attrVal);
    });
  }

  function fillInPrivatePartOfHtmlForm() {
    var privateValues = JSON.parse($('#peer-evaluation-private-content').val());
    $.each(privateValues, function (attrName, attrVal) {
      $('#eval-private input[type=radio][name="' + attrName + '"][value="' + attrVal + '"]').attr('checked', 'checked');
      $('#eval-private textarea[name="' + attrName + '"]').val(attrVal);
    });
  }

  function disableAllEvalFormInputs() {
    $('input').attr('disabled', 'disabled');
    $('textarea').attr('disabled', 'disabled');
  }
});
