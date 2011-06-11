function getCurrentPage () {
	return parseInt($("#page-num").html(), 10)
}

function getNewPage (direction) {
	var currentPage = getCurrentPage();
	
	if (direction == "next") {
		return currentPage+1;
	}
	return currentPage-1;			
}

function updatePage (direction) {
	if (direction == "beginning")
		goToPage(1);
	else
		goToPage(getNewPage(direction));
}

function goToPage (new_page_num) {
	var currentPage = getCurrentPage();

	hide("page_"+currentPage);
	show("page_"+new_page_num);
	$("#page-num").html(new_page_num);
	updateBookNavLinks(new_page_num);				
}

function updateBookNavLinks(currentPage) {
	if (currentPage == 1) {
		hideButton("prev-page")
	}
	else if (currentPage > 1) {
		showButton("prev-page")
		if (currentPage == parseInt($("#total-pages").html())) {
			hideButton("next-page")
		}
		else if (currentPage < parseInt($("#total-pages").html())) {
			showButton("next-page")
		}
	}
}