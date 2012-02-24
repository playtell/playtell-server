
function showBook(title, currentPage, totalPages) { 
	pageFlipInit();

	// position the book on the page centered horizontally
	var rightmost = $('.activity-content').outerWidth()-$('.next-container').offset().left; //inside of right arrow
	var bookPos = rightmost < $('.activity-content').outerWidth()-$("#book").outerWidth() ?
		($('.activity-content').outerWidth()-$("#book").outerWidth())/2 : rightmost;
	//var bookPos = $('.activity-content').outerWidth() > $("#book").outerWidth() ?
	//    ($('.activity-content').outerWidth()-$("#book").outerWidth())/2 : 5;
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

//this is our hack to do "audio-only." we keep the video session alive, but hide the video windows
function toggleVideoWindows() {
	var new_bottom_pos = ($('.chat-window-container').css('bottom') == '0px') ?
		PUBLISHER_HEIGHT+2 : 0;
	
	$('.chat-window-container').animate({ 
		bottom: new_bottom_pos
	});
}

//captures images from video cams and creates html elements
function takeSnapshot() {
	var pubImgData = publisher.getImgData();
	var subImgData; 
	var pubImg; 
	var subImg;
			
	pubImg = document.createElement("img");
	pubImg.setAttribute("src", "data:image/png;base64," + pubImgData);	
	
	if (subscribers[0]) {
		subImgData = subscribers[0].getImgData();	
		subImg = document.createElement("img");
		subImg.setAttribute("src", "data:image/png;base64," + subImgData);
		subImg.setAttribute("class", "famCam-keepsake");
	}
	
	pubImg.setAttribute("class", "myCam-keepsake");
	
	addToKeepsakes(pubImg, subImg);
}

//takes in two images and adds them to the keepsake frame, creating a div on the page with the keepsake in it inside of the keepsake-container
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

//removes images from the end of book keepsake frame. should really be called removeSpecialKeepsakes
function removeKeepsakes() {
	$('#myCam-keepsake img').remove();
	$('#famCam-keepsake img').remove();
}

function enableButtons() {
	$('a').attr("disabled", false);
	
	$('#snapshot-link').click(function() {
		takeSnapshot();
	});
	
	//currently the reconnect button makes the app fullscreen
	app = document.getElementById('videos');
    $('#reconnect-link').live('click', function() {
		if (fullScreenApi.supportsFullScreen) {
        	fullScreenApi.requestFullScreen(app);
		}
		else {
			maxWindow();
		}
    }, true);

	//hides the video chat windows. controlled via a hot corner on the bottom right of the toybox icon bar
	$("#audio-toggle").live("click", function() {
		toggleVideoWindows();
		syncToServer(0, 99); //TODO
		return false;
	});
	
	$("#beginning-link").click(function() {
		goToPage(1, false);
	});
}

function enableISpy(gameKey) {
	$('div.ispy-item').live("click", function() {
		var correct;
		if (!$(this).hasClass("selected")) {
			if (!gameKey[parseInt($(this).attr("data-item"))]) {
				iSpyWrong($(this));
				correct = false;
			}
			else { 
				iSpyCorrect($(this));
				correct = true;
			}
			syncGameToServer($(this).attr("data-item"), correct, 1002); //TODO
		}
	});
}

function iSpyCorrect(item) {
	item.addClass("selected"); 
}

function iSpyWrong(item) {
	item.animate({
		left: '-=25' 
		}, 100, function () {
			$(this).animate({
				left: '+=50'
			}, 100, function () {
				$(this).animate({
					left: '-=25'
					}, 100);
				});
	});
}

//DEPRECATED sends payload of current playdate state to server
function syncToServer(new_page, change) {
	$.ajax({
		url: "/update_page.js?newPage=" + new_page + "&playdateChange=" + change,
		type: "POST",
		success: function() {
			session.signal();
		}
	});
}


//right now this is very specific to the ispy game. total hack: using the newPage field usually used for books to capture which item has been chosen.
function syncGameToServer(item, correct, change) {
	$.ajax({
		url: "/update_page.js?item=" + item + "&correct=" + correct + "&playdateChange=" + change,
		type: "POST",
		success: function() {
			session.signal();
		}
	});	
}