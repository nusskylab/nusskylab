'use strict';
$(document).ready(function () {
  var mentor_forms_idx = 0;
  var mentor_forms_count = 1;

  $("#add_mentor").click(function() {
    addMentorForm();
    mentor_forms_count++;
    if (mentor_forms_count > 1) {
      showDeleteButtons();
    }
  });

  $('#new_mentor').on('click', '.mentor-form-delete-btn', function() {
    $(this).closest('.batch_create_mentors_fieldset').remove();
    mentor_forms_count--;
    if (mentor_forms_count <= 1) {
      hideDeleteButtons();
    }
  })

  function showDeleteButtons() {
    $('.mentor-form-delete-btn').each(function(idx, el) {
      $(this).removeClass('hide');
    })
  }

  function hideDeleteButtons() {
    $('.mentor-form-delete-btn').each(function(idx, el) {
      $(this).addClass('hide');
    })
  }

  function addMentorForm() {
    mentor_forms_idx++;
    const clone = $(".batch_create_mentors_fieldset:first").clone();

    const new_user_select_id = `users_user_id${mentor_forms_idx}`;
    const new_slide_link_id = `users_slide_link${mentor_forms_idx}`;

    clone.find('[id^=users_user_id]').prop('id', new_user_select_id);
    clone.find('[id^=users_slide_link]').prop('id', new_slide_link_id);

    clone.find('label[for^=users_user_id]').prop('for', new_user_select_id);
    clone.find('label[for^=users_slide_link]').prop('for', new_slide_link_id);

    clone.find("[data-id^=users_user_id]").remove();
    clone.appendTo("#batch_create_mentors_form");
    clone.find('.selectpicker').selectpicker();

    clone.find('input[id^=users_slide_link]').val('');
  }
});
