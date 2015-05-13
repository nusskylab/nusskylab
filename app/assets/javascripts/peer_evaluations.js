'use strict';
$(document).ready(function () {
  if ($('#main-content > div > div.panel-heading > h3').html() === 'Edit peer evaluation') {
    //$('#eval-public').html($('#peer-evaluation-public-content').val());
    //$('#eval-private').html($('#peer-evaluation-private-content').val());
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
});
