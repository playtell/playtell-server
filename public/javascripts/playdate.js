function showBook(title, currentPage, totalPages) { 
	$('#page_'+currentPage).animate({
		left: 0
	});
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
	
	var new_left_position = (current_page_num < new_page_num) ? 
		-$('#'+current_page_div).outerWidth() : $('#'+current_page_div).outerWidth();
	
	$('#'+current_page_div).animate({
		left: new_left_position
	});
	$('#'+new_page_div).animate({
		left: 0
	});
	//if beginning, then set all lefts to outerwidth

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
		showButton("first-page");
		if (currentPage == parseInt($("#total-pages").html())) {
			hideButton("next-page");
		}
		else if (currentPage < parseInt($("#total-pages").html())) {
			showButton("next-page");
		}
	}
} 
