function show(id) {
	$("#"+id).removeClass('hidden')
}

function hide(id) {
	$("#"+id).addClass('hidden')
	
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
			onLoad: function() { 
				show('early-access-submit');
			    show('access-lightbox-text');
				$('#access-lightbox-text').find('input[type=email]:first').focus();
			},
			onClose: function() {
				$('#thank-you').css("display", "none");
				hide('access-lightbox-text');
				$('#loader').removeClass('inline');
				hide('loader');
			} 
		});
	});
	
	$('#early-access-submit')
		.click(function() {
			hide('early-access-submit');
			$('#loader').addClass('inline');
			show('loader');
	});
	
	$('.login-link').click(function() {
		$('#early-access-lightbox').lightbox_me({
		    centered: true, 
			onLoad: function() { 
			    show('login-lightbox-text');
				$('#login-lightbox-text').find('input[type=text]:first').focus();
			},
			onClose: function () {
				hide('login-lightbox-text');
			} 
		});
	});
	// add alt text to title attribute of all images
	$('img').each( function() {
    	var o = $(this);
    	if( ! o.attr('title') && o.attr('alt') ) {
			o.attr('title', o.attr('alt') );
		}
  	});
	$('input[type="image"]').each( function() {
    	var o = $(this);
    	if( ! o.attr('title') && o.attr('alt') ) {
			o.attr('title', o.attr('alt') );
		}
  	});
});
