//= require validator
'use strict';
$(document).ready(function () {
    $('form[id^=edit_milestone], form[id^=new_milestone]').validator();
});
