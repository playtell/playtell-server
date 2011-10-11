function showBook(title, currentPage, totalPages) { 
	$('#total-pages').html(totalPages);
	$('#page-num').html(currentPage);
	$('#book-title').val(title);
	updateBookNavLinks(currentPage);
	
	$('#book').booklet({
		width: 1000,
		height: 520, 
		closed: true,
		manual: false,
		hovers: false,
		pageNumbers: false, 
		after: function(opts){
			$('#new-page').val(opts.curr);
			$.ajax({
				url: "/update_page.js?newPage=" + opts.curr + "&playdateChange=" + 101,
				type: "POST",
				success: function() {
					session.signal();
				}
			});
			if (opts.curr == 2) {
				takeSnapshotNew();
			}
			if (parseInt($('#total-pages').html())%2 == 0) {
				if (opts.curr == $('#total-pages').html()) {
					$('.back-cover').show();
					$('.back-cover').css("z-index", 20);
				}
			}
			else if (opts.curr == parseInt($('#total-pages').html())+1) {
				$('.back-cover').show();
				$('.back-cover').css("z-index", 20);
			}
			else {
				$('.back-cover').hide();
			}
		}
	});
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

	$('#book').booklet(new_page_num);
	
	$("#page-num").html(new_page_num);
	updateBookNavLinks(new_page_num);				
}

function updateBookNavLinks(currentPage) {
/*	if (currentPage == 1) {
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
	}*/
} 

function toggleToyBox() {
	var new_bottom_pos = ($('#bottom-drawer').css('bottom') == '0px') ?
		-$('#bottom-drawer').outerHeight() + $('#links').outerHeight() : 0;
	
	if ($('#player-container').is(':visible')) {
		if (new_bottom_pos == 0) {
			$("#player-container iframe").css('width', '200px')
	    	$("#player-container iframe").css('height', '200px')
		}
		else {
			$('#player').remove();
			createPlayer();
		}
	}
	
	$('#bottom-drawer').animate({ 
		bottom: new_bottom_pos
	});
}

function hideToyBox() {
	var new_bottom_pos = -$('#bottom-drawer').outerHeight() + $('#links').outerHeight();
	
	$('#bottom-drawer').animate({ 
		bottom: new_bottom_pos
	});
	
	if ($('#player-container').is(':visible')) {
		$('#player').remove();
	}
}

function removeKeepsakes() {
	$('#myCam-keepsake img').remove();
	$('#famCam-keepsake img').remove();
}

