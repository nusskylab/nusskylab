'use strict';
function createModalBox(team_id) {
  var modal = document.getElementById("modal_".concat(team_id));
  var button = document.getElementById("button_".concat(team_id));
  var span = modal.getElementsByClassName("close")[0];
  modal.style.display = "block";
  // Close using the window close.
  span.addEventListener('click', function() {
    closeModal(modal);
  });
  // Close modal outside of the modal
  window.addEventListener('click', function(event) {
    if (event.target == modal) {
      closeModal(modal);
    }
  });
}

function closeModal(modal) {
  modal.style.display = "none";
}

document.addEventListener('DOMContentLoaded', function () {
  Array.from(document.getElementsByClassName("button_team")).forEach(function(element) { 
    element.addEventListener('click', function() {
      createModalBox(element.id.slice(element.id.indexOf("_") + 1));
    });
  });
});
