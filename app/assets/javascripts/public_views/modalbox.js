function createModalBox(team_name) {
	var modal = document.getElementById("modal_".concat(team_name));
	var button = document.getElementById("button_".concat(team_name));
	var span = document.getElementsByClassName("close")[0];
	console.log("Success!");
	modal.style.display = "block";
	span.onclick = function() {
		modal.style.display = "none";
	}
	window.onclick = function(event) {
		if (event.target == modal) {
			modal.style.display = "none";
		}
	}
}