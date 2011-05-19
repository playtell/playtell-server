// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$('#create-playdate').click(function() {
		$('#connection-type').val("create");
	});

	$('#join-playdate').click(function() {
		$('#connection-type').val("join");
	});	
});

function show(id) {
	$("#"+id).toggleClass('hidden', false)
}

function hide(id) {
	$("#"+id).toggleClass('hidden', true)
	
}

function showButton(id) {
	$("#"+id).removeAttr('disabled')	
}

function hideButton(id) {
	$("#"+id).attr('disabled', 'disabled')
}
