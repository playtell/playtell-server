// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function show(id) {
	$("#"+id).toggleClass('hidden', false)
}

function hide(id) {
	$("#"+id).toggleClass('hidden', true)
	
}

//these actually disable and enable even though they're called "show"
function showButton(id) {
	$("#"+id).removeAttr('disabled')	
}

function hideButton(id) {
	$("#"+id).attr('disabled', 'disabled')
}

function maxWindow() {
    window.open('http://localhost:3000/playdate', 'title' , 'type=fullWindow, fullscreen, scrollbars=yes');
}

$(function() {
	$('#early-access').click(function() {
		$('#early-access-lightbox').lightbox_me({
		    centered: true, 
		});
	});
});