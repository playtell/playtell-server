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


function getPageImageFilePath(directory, pageNum) {
   //for S3 storage, e.g. https://ragatzi.s3.amazonaws.com/little-red-riding-hood-page1.png
   path = "https://ragatzi.s3.amazonaws.com/" + directory; 
   if (pageNum > 0) {
     path += "-" + "page" + pageNum
   }
   return path += ".png"
}

$(function() {
	
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
