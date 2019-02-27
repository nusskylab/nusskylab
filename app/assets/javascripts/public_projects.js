'use strict';
$(document).ready(function () {
  $("body").on("click", ".button_team", function(event) {
    //theoretically doesn't need a closest() call but chrome is weird
    var clickedButton = $(event.target).closest(".button_team");
    var team_id = clickedButton.data("team-id");
    var modal_id = "#modal_" + team_id;
    var modal = $(modal_id);
    var span = document.getElementsByClassName("close")[0];
    console.log("Success!");
    modal.show();
    span.onclick = function() {
      modal.hide();
    }
    window.onclick = function(event) {
      if (event.target == modal) {
        modal.hide();
      }
    }
  });
});
