function replaceImg(image, team_level) {
  if (team_level == 'vostok') {
    return $(image).attr('src', "/assets/Vostok_Icon.jpg");
  } else if (team_level == 'project_gemini') {
    return $(image).attr('src', "/assets/Project_Gemini_Icon.png");
  } else {
    return $(image).attr('src', "/assets/Apollo_11_Icon.png");
  }
}
