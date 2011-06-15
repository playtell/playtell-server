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
	
	if (current_page_num < new_page_num) { //next page
		$('#'+current_page_div).slideUp('slow');
		$('#'+new_page_div).slideDown('slow');
	}
	else { //prev page or beginning
		$('#'+new_page_div).slideDown('slow');
		$('#'+current_page_div).slideUp('slow');
	}
	$("#page-num").html(new_page_num);
	updateBookNavLinks(new_page_num);				
}

function updateBookNavLinks(currentPage) {
	if (currentPage == 1) {
		hideButton("prev-page");
		hideButton("first-page");
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