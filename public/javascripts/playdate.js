function showBook(title, currentPage, totalPages) { 
	//$('#page_'+currentPage).animate({
	//	left: 0
	//});
	//show("page_"+currentPage); - remnant of no animation
	$('#total-pages').html(totalPages);
	$('#page-num').html(currentPage);
	$('#book-title').val(title);
	updateBookNavLinks(currentPage);
	
}

function getCurrentPage () {
	return parseInt($("#page-num").html(), 10)
}

function updatePage (direction) {
	if (direction == "beginning")
		goToPage(1);
	else
		goToPage(getNewPage(getCurrentPage(), direction));
}

function getNewPage (current_page, direction) {
	if (direction == "next") {
		return current_page+1;
	}
	return current_page-1;			
}

function goToPage (new_page_num) {
	var current_page_num = getCurrentPage();
	var current_page_div = "page_" + current_page_num;
	var new_page_div = "page_" + new_page_num;
	
	// set the position off the page: negative if moving forward a page, positive if moving back
	var new_left_position = (current_page_num < new_page_num) ? 
		-$('#'+current_page_div).outerWidth() : $('#'+current_page_div).outerWidth();
	
	$('#'+current_page_div).animate({
		left: new_left_position
	});
	$('#'+new_page_div).animate({
		left: 0
	});
	//if beginning, then set all lefts to outerwidth
	if (new_page_num == 1) {
		var i;
		for (i=1; i<=$('#total-pages').html(); i++) {
			$('#'+"page_"+i).css('left', $('#'+"page_"+i).outerWidth());
		}
	}

	$("#page-num").html(new_page_num);
	updateBookNavLinks(new_page_num);				
}

function updateBookNavLinks(currentPage) {
	if (currentPage == 1) {
		hideButton("prev-page");
		hideButton("first-page");
		showButton("next-page");
	}
	else if (currentPage > 1) {
		showButton("prev-page");
		if (currentPage == parseInt($("#total-pages").html())) {
			hideButton("next-page");
			$('#first-page').show();
		}
		else if (currentPage < parseInt($("#total-pages").html())) {
			showButton("next-page");
			$('#first-page').hide();
		}
	}
} 

function toggleToyBox() {
	var new_bottom_pos = ($('#bottom-drawer').css('bottom') == '0px') ?
		-$('#bottom-drawer').outerHeight() + $('#links').outerHeight() : 0;
	
	$('#bottom-drawer').animate({ 
		bottom: new_bottom_pos
	});
}

function hideToyBox() {
	var new_bottom_pos = -$('#bottom-drawer').outerHeight() + $('#links').outerHeight();
	
	$('#bottom-drawer').animate({ 
		bottom: new_bottom_pos
	});
}

//keyboard shortcuts for book navigation: left arrow and right arrow
$(document).bind("keydown", function(event)
{
    var key = event.keyCode;
    if(key == 37) //left arrow
    {
		if (!$('#prev-page').is(':disabled')) {
			$('#page-direction').val("previous");
			$('#new-page').val(getNewPage(getCurrentPage(), "previous"));
			$('#turn-page').submit();
		}
    }
    else if(key == 39) //right arrow
    {
		if (!$('#next-page').is(':disabled')) {
			$('#page-direction').val("next");
			$('#new-page').val(getNewPage(getCurrentPage(), "next"));
			$('#turn-page').submit();
		}
    }
});
