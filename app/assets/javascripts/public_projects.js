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

function replaceImg(image, team_level) {
  if (team_level == 'vostok') {
    return $(image).attr('src', "/assets/Vostok_Icon.jpg");
  } else if (team_level == 'project_gemini') {
    return $(image).attr('src', "/assets/Project_Gemini_Icon.png");
  } else if (team_level == 'apollo_11') {
    return $(image).attr('src', "/assets/Apollo_11_Icon.png");
  } else {
    return $(image).attr('src',"/assets/Artemis_Icon.png");
  }
}

document.addEventListener('DOMContentLoaded', function () {
  Array.from(document.getElementsByClassName("button_team")).forEach(function(element) { 
    element.addEventListener('click', function() {
      createModalBox(element.id.slice(element.id.indexOf("_") + 1));
    });
  });
});
