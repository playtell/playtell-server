function showBook(title, currentPage, totalPages) { 
	$('#total-pages').html(totalPages);
	$('#page-num').html(currentPage);
//	$('#book-title').val(title);
//	updateBookNavLinks(currentPage);
	
	$('#book').booklet({
		width: 1000,
		height: 540, 
		closed: true,
		manual: false,
		keyboard: false,
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

function getNewPage (current_page, direction) {
	if (direction == "next") {
		return current_page+1;
	}
	return current_page-1;			
}

function goToPage (new_page_num, is_slideshow) {
	var current_page_num = getCurrentPage();
	var div_target = is_slideshow ? "#slide_" : "#page_";
	var current_page_div = div_target + current_page_num;
	var new_page_div = div_target + new_page_num;
	var new_left_pos;
	
	if (is_slideshow) {
		new_left_pos = (current_page_num < new_page_num) ? 
			-$(current_page_div).outerWidth() : $(current_page_div).outerWidth()*2; 
			
		$(current_page_div).animate({ 
			left: new_left_pos
		});
		$(new_page_div).animate({ 
			left: 275
		});
		updateBookNavLinks(new_page_num);						
	}
	else {
		$('#book').booklet(new_page_num);
	}
	$("#page-num").html(new_page_num);
}

function updateBookNavLinks(currentPage) {
	if (currentPage == 1) {
		hideButton("previous-link");
		showButton("next-link");
	}
	else if (currentPage > 1) {
		showButton("previous-link");
		if (currentPage == parseInt($("#total-pages").html())) {
			hideButton("next-link");
		}
		else if (currentPage < parseInt($("#total-pages").html())) {
			showButton("next-link");
		}
	}
} 

function toggleToyBox() {
	var new_bottom_pos = ($('#bottom-drawer').css('bottom') == '0px') ?
		-$('#bottom-drawer').outerHeight() + $('#links').outerHeight() : 0;
	
	//youtube player can't be occluded according to their TOS, so player gets smaller when toybox is open
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

function syncToServer(new_page, change) {
	$.ajax({
		url: "/update_page.js?newPage=" + new_page + "&playdateChange=" + change,
		type: "POST",
		success: function() {
			session.signal();
		}
	});
}


