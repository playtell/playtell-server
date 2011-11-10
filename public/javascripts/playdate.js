function showBook(title, currentPage, totalPages) { 
	$('#total-pages').html(totalPages);
	$('#page-num').html(currentPage);
	
	var c = $('.activity-content').outerWidth();
	var b = $("#book").outerWidth();
	var bookPos = $('.activity-content').outerWidth() > $("#book").outerWidth() ?
		($('.activity-content').outerWidth()-$("#book").outerWidth())/2 : 5;
	$('#book').attr("style", "right: "+bookPos+"px");
	
	// Resize the canvas to match the book size
	canvas.width = BOOK_WIDTH + ( CANVAS_PADDING * 2 );
	canvas.height = BOOK_HEIGHT + ( CANVAS_PADDING * 2 );

	// Offset the canvas so that it's padding is evenly spread around the book
	canvas.style.top = -CANVAS_PADDING + "px";
	//canvas.style.left = -CANVAS_PADDING + "px";
	canvas.style.right = (bookPos - CANVAS_PADDING) + "px";
	
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

function goToPage (new_page_num, activity) {
	var current_page_num = getCurrentPage();

	var div_target;
	
	if (activity == "slide") {
		div_target = "#slide_";
	}
	else if (activity == "keepsake") {
		div_target = "#keepsake_";
	}
	else {
		div_target = "#page_";
	}

	var current_page_div = div_target + current_page_num;
	var new_page_div = div_target + new_page_num;
	var new_left_pos;
	var show_left_pos;
	
	if (activity == "slide" || activity == "keepsake") {
		if ($('#slide-keepsake').is(':visible')) {
			$('#slide-keepsake').hide();
		}
		new_left_pos = (current_page_num < new_page_num) ? 
			-1500 : 1500;
//			-$(current_page_div).outerWidth() : $(current_page_div).outerWidth()*2; 
		show_left_pos = (activity == "slide") ? 
		($('.slides').outerWidth())/4 : 490;
		
		$(current_page_div).animate({ 
			left: new_left_pos
		});
		$(new_page_div).animate({ 
			left: show_left_pos
		});
		updateBookNavLinks(new_page_num);
		if (activity == "slide") {
			if (current_page_num == 3) {
				takeSnapshot();	
				createSpecialKeepsake('#slide-keepsake');
			}
			//if (current_page_num == parseInt($("#total-pages").html())) {
			//	$('#slide-keepsake').show();
			//}					
		}
	}
	$("#page-num").html(new_page_num);
}

//disable book nav links as appropriate
function updateBookNavLinks(currentPage) {
	if (currentPage == 1) {
		hideButton("previous-link");
		showButton("next-link");
	}
	else if (currentPage > 1) {
		showButton("previous-link");
		if (currentPage >= parseInt($("#total-pages").html())) {
			hideButton("next-link");
		}
		else if (currentPage < parseInt($("#total-pages").html())) {
			showButton("next-link");
		}
	}
} 

//expand/collapse the toy box
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

//captures images from video cams and creates html elements
function takeSnapshot() {
	var pubImgData = publisher.getImgData();
	var subImgData; 
	var pubImg; 
	var subImg;
	
	//removeKeepsakes();
		
	pubImg = document.createElement("img");
	pubImg.setAttribute("src", "data:image/png;base64," + pubImgData);	
	
	if (subscribers[0]) {
		subImgData = subscribers[0].getImgData();	
		subImg = document.createElement("img");
		subImg.setAttribute("src", "data:image/png;base64," + subImgData);
		subImg.setAttribute("class", "famCam-keepsake");
//		$("#book-keepsake").append(subImg);
	}
	
	pubImg.setAttribute("class", "myCam-keepsake");
//	$("#book-keepsake").append(pubImg);
	
	addToKeepsakes(pubImg, subImg);
}

//takes in two images and adds them to the keepsake frame, creating a div on the page with the keepsake in it
function addToKeepsakes(pubImg, subImg) {
	num_keepsakes++;
	$('#total-pages').html(num_keepsakes);
	
	var d = $("#keepsake_"+num_keepsakes);
	var kDiv= document.createElement("div");
	kDiv.setAttribute("id", "keepsake_"+num_keepsakes);
	kDiv.setAttribute("class", "keepsake");
	if (num_keepsakes == 1) {
		kDiv.setAttribute("style", "left: 440px");
	}
	kDiv.appendChild(pubImg);	
	if (subImg) { kDiv.appendChild(subImg); }
	
	document.getElementById("keepsake-container").appendChild(kDiv);
}

function createSpecialKeepsake(divId) {	
	bookEnd = $('#keepsake_'+num_keepsakes).clone();
	bookEnd.removeAttr("id");
	bookEnd.removeAttr("style");
	$(divId).append(bookEnd);	
}

//removes images from the end of book keepsake frame
function removeKeepsakes() {
	$('#myCam-keepsake img').remove();
	$('#famCam-keepsake img').remove();
}

//sends payload to current playdate state to server
function syncToServer(new_page, change) {
	$.ajax({
		url: "/update_page.js?newPage=" + new_page + "&playdateChange=" + change,
		type: "POST",
		success: function() {
			session.signal();
		}
	});
}

function enableButtons(){
	$('a').attr("disabled", false);
	
	$('#snapshot-link').click(function() {
		takeSnapshot();
	});
	
	$('#toybox-link').click(function() {
		toggleToyBox();
	});
	
	app = document.getElementById('videos');
    $('#reconnect-link').live('click', function() {
		if (fullScreenApi.supportsFullScreen) {
        	fullScreenApi.requestFullScreen(app);
		}
		else {
			maxWindow();
		}
    }, true);
	
	$("#beginning-link").click(function() {
		goToPage(1, false);
	});
}

function disableNavButtons() {
	$("#next-link").die("click");
	$("#previous-link").die("click");
	
	$(document).unbind('keyup', 'left');
	$(document).bind('keyup', 'right');
}

function enableNavButtons(activity, playdateChange) {
	disableNavButtons();
	
	$("#next-link").live("click", function() {
		goToPage(getNewPage(getCurrentPage(),"next"), activity);
		syncToServer(getCurrentPage(), playdateChange);
		return false;
	});
	$("#previous-link").live("click", function() {
		goToPage(getNewPage(getCurrentPage(),"prev"), activity);
		syncToServer(getCurrentPage(), playdateChange);
		return false;
	});
	
	$(document).bind('keyup', 'left', function() {
		if (!$('#previous-link').is(':disabled')) {
			goToPage(getNewPage(getCurrentPage(),"prev"), activity);
			syncToServer(getCurrentPage(), playdateChange);
			return false;
	    }
	});
	
	$(document).bind('keyup', 'right', function() {
		if (!$('#next-link').is(':disabled')) {
			goToPage(getNewPage(getCurrentPage(),"next"), activity);
			syncToServer(getCurrentPage(), playdateChange);
			return false;
	    }
	});
	
	$(document).bind('keyup', 'up', function() {
	});
}


