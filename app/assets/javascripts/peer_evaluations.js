'use strict';
$(document).ready(function () {
  if ($('#main-content > div > div.panel-heading > h3').html() === 'Edit peer evaluation') {
    $('#eval-public').html($('#peer-evaluation-public-content').val());
    $('#eval-private').html($('#peer-evaluation-private-content').val());
  }

  $('.new_peer_evaluation').on('submit', function () {
    $('#peer-evaluation-public-content').val($('#eval-public').html());
    $('#peer-evaluation-private-content').val($('#eval-private').html());
  });

  $('.edit_peer_evaluation').on('submit', function () {
    $('#peer-evaluation-public-content').val($('#eval-public').html());
    $('#peer-evaluation-private-content').val($('#eval-private').html());
  });
});
