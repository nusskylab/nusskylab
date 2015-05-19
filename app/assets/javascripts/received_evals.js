'use strict';
$(document).ready(function () {
  $('#public-content > div > .eval-public-value').each(function (idx, itm) {
    fillEvalHtmlForm(itm, '.eval-public-part');
  });
  $('#private-content > #private-part-compiled > div > .eval-private-value').each(function (idx, itm) {
    fillEvalHtmlForm(itm, '.eval-private-part');
  });

  disableAllEvalFormInputs();

  function fillEvalHtmlForm(itm, formClass) {
    try {
      var publicValues = JSON.parse($(itm).html());
      $.each(publicValues, function (attrName, attrVal) {
        var radioSelector = formClass + ' > div input[type=radio][name="' + attrName + '"][value="' + attrVal + '"]';
        $(itm).parent().find(radioSelector).attr('checked', 'checked');
        var textareaSlector = formClass + ' > div textarea[name="' + attrName + '"]';
        $(textareaSlector).val(attrVal);
      });
    } catch (err) {
    }
  }

  function disableAllEvalFormInputs() {
    $('input').attr('disabled', 'disabled');
    $('textarea').attr('disabled', 'disabled');
  }
});
