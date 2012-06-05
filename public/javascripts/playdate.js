function initPlaydate(pusher_channel_name) {
	
	inPlaydate = true;
	$('#pusher-channel-name').html(pusher_channel_name);	
	playdateChannel = pusher.subscribe(pusher_channel_name);
	listenForEndPlaydate();
	listenForChangeBook();
	
	enableButtons();
	enableToySelectors();
	
}

function endPlaydate() {
	pusher.unsubscribe($("#pusher-channel-name").html()); //disconnect on pusher
	$.get("/disconnect_playdate"); //disconnect on playtell 
	
	// prompt for feedback:
	if (inPlaydate) {
		$('#feedback-lightbox').lightbox_me({
		    centered: true, 
			closeClick: false,
			onClose: function () {
				document.location.href='/users/' + $('#current-user').html();
			}
		});
	}
	inPlaydate = false;
}

//expects either the id of the user or a direct link to the user's profile photo
//sets the user's profile pic in the container that will eventually be replaced by the video chat window top left
function setPlaymatePhoto(playmate_id, photo_url) {
	
	var src = playmate_id ? $('a.*[data-friendid=' + playmate_id + '] img.friend-item').attr("src") : photo_url
	
	$('.playmate-cam-container').html('<img src=' + src + '>');	
	
}

function animatePhotos() {
	$('.cam-container').animate({
		left: 0
	});
}

function enableButtons() {

	$('#toybox-link').on(tablet ? 'touchstart' : 'click', function() {
		toggleToyBox();
	});

	$('#disconnect-link img').draggable({
		axis:'x', 
		containment:'parent', 
		revert:'invalid', 
		revertDuration:200,
	});
	$('#ended').droppable({
		drop: function() { 
			$('#disconnect-link').addClass('active');
			endPlaydate(); 
		},
		tolerance: 'touch'
	});

	$('#camera-link').on(tablet ? 'touchstart' : 'click', function() {
		takePhoto();
	});

}

//expand or collapse the toy box and bring it to the front
function toggleToyBox() {
	
	var new_pos, z;
	
	if ($('#toybox').css('right') == '0px') {   //toybox is currently open
		new_pos = -$('#toybox').outerWidth() + $('#toybox-toggle').outerWidth();
		z = '1';
	}
	else {
		new_pos = 0;
		z = '1000';
	} 
	
	$('#toybox').css('z-index', z);
	$('#toybox').animate({ 
		right: new_pos
	});
	
	$('#toybox-link').toggleClass("active");
	
}

function hideToyBox() {
	
	var new_pos = -$('#toybox').outerWidth() + $('#toybox-toggle').outerWidth();
	
	$('#toybox').css('z-index', '1');
	$('#toybox').animate({ 
		right: new_pos
	});
	$('#toybox-link').removeClass("active");
	
}

function enableToySelectors() {
	
	$('.content-item').on(tablet ? 'touchstart' : 'click', function() {
		resetPlayspace(this);
		syncToServerReturnData(this.getAttribute('data-playdatechange'),
								this.getAttribute('data-activityid'));
	});
	
}

// sets element as the currently selected content item in the toybox
function resetSelectedContentItem(element) {
	
	$('.selected-indicator').hide();
	$('.content-item').removeClass("selected-content-item");
	
	var newPos = $(element).position().top + $(element).outerHeight()/2 - 5;
	$('.selected-indicator').css("top", newPos);
	$(element).addClass("selected-content-item");
	$('.selected-indicator').show();
	
}

//replaces whatever is in the playspace with the loading icon
function resetPlayspace(toybox_element) {
	
	if ($('.instructions').is(":visible")) { $('.instructions').fadeOut('fast'); }

	resetSelectedContentItem(toybox_element);
	hideToyBox();

	$('#keepsake-container').hide();
	$('.camera-container').hide();
	$('.book-container').hide();
	$('.pages').hide();
	page = 0;
	$('.book-nav').hide();

	$('.loading').show();

}

function doChangeBook(book) {	
	$('#total-pages').html(book.pages.length);
	$('#page-num').html(1);
	
	if (!$('#pages-' + book.id).hasClass("full")) {
		b = new PTBook();
		page = 0;
		b.createActivityFromJSON(book);
	}
	mySwipe = new Swipe(
	  document.getElementById('pages-'+ book.id), {
		speed: 500, 
		callback: function() {
			updateBookNavLinks()
			if (!mySwipe.getResponder()) {
				//page = mySwipe.getPos();
				syncToServerNoData(101, "new_page_num=" + page);
			}
		}
	  }
	);
	
	$('.loading').hide();
	
	$('#pages-' + book.id).show(); 
	
	$('.book-container').show();
	mySwipe.setup();
		
	enableNavButtons("book", 101);
	updateBookNavLinks();
	$('.book-nav').show();
	
	listenForTurnPage();
	listenForFinger();
}

function doTurnOnCamera() {
	$('.loading').hide();
	$('#camera-container').show();
	session.addEventListener('sessionConnected', sessionConnectedHandler);      
	connect(apiKey, token);
}

function takePhoto() {
	var imgData = publisher.getImgData();

	var img = document.createElement("img");
	img.setAttribute("src", "data:image/png;base64," + imgData);
	var imgWin = window.open("about:blank", "Screenshot");
	imgWin.document.write("<body></body>");
	imgWin.document.body.appendChild(img);
	
	syncToServerPhoto(imgData);
}

//disable book nav links as appropriate
function updateBookNavLinks() {
	
	var page = mySwipe.getPos();
	
	if (page == 0) {
		$("#previous-link").addClass("hidden");
		$("#previous-link").addClass("disabled");
		$("#next-link").removeClass("disabled");
		$("#next-link").addClass("title");
	}
	else if (page > 0) {
		$("#previous-link").removeClass("hidden");
		$("#next-link").removeClass("title");
		if (page > 1) {
			$("#previous-link").removeClass("disabled");
		}
		if (page >= mySwipe.getLength()-1) {
			$("#next-link").addClass("disabled");
			$("#next-link").addClass("hidden");
		}
		else if (page < mySwipe.getLength()-1) {
			$("#next-link").removeClass("disabled");
			$("#next-link").removeClass("hidden");
		}
	}
	
} 

function disableNavButtons() {
	
	$("#next-link").die("click");
	$("#previous-link").die("click");

}

function enableNavButtons(activity, playdateChange) {

	disableNavButtons();

	$("#next-link").live("click", function n(e) {
		page++;
	    syncToServerNoData(playdateChange, "new_page_num=" + page);
		mySwipe.next();
		return false;
    });

	$("#previous-link").live("click", function p(e) {
		page--;
	    syncToServerNoData(playdateChange, "new_page_num=" + page);
		mySwipe.prev();
		return false;
    });

	var x,y;
	if (tablet) {
		$('#book').on('touchstart', function(e) {
			x = event.touches[0].pageX - $('#finger').outerWidth()/2;
			y = event.touches[0].pageY - $('#finger').outerHeight()/2;
			syncToServerNoData(1, "x=" + x + "&y=" + y);
		});
	}
	else {
		$('#book').live('click', function b(e) {
			x = e.pageX - $('#finger').outerWidth()/2;
			y = e.pageY - $('#finger').outerHeight()/2;
			syncToServerNoData(1, "x=" + x + "&y=" + y);
		});
	}
	

}

//used for changing activity. 
//sends payload of current playdate state to server, then updates playspace with callback data
function syncToServerReturnData(playdate_change, activityID) {
	
	$.getJSON(
		"/update_playdate", 
		{ 
			playdateChange: playdate_change, 
		  	book_id: activityID 
		},		
		function(data) {
			if (data.book) {
				doChangeBook(data.book);
			}
			else {
				//doTurnOnCamera();
			}
		}
	);
	
}

//used for in-activity changes like turn page
//sends payload of current playdate state to server
function syncToServerNoData(playdate_change, params) {
	
	var data = "playdateChange=" + playdate_change;
	if (params) {
		data += "&" + params;
	}
	$.ajax({
		url: "/update_playdate.js",
		data: data,
		type: "POST"
	});
	
}

function syncToServerPhoto(photo_data) {
	
	$.ajax({
		url: "/playdate_photos.js",
		data: "photo_data=" + photo_data,
		type: "POST"
	});
	
}

// the next few fns are for REQUESTING, JOINING, DISCONNECTING from playdates (ie stuff that happens before player is in a playdate)

//pings the server directly first to check for a requesting playdate; listens for pusher notification if there isn't yet a requesting playdate
function checkForPlaydateRequest() {
	
	$.getJSON(
		"/playdate_requested", 		
		function(data) {
			if (data) {
				showPlaydateRequest(data);
				//join private playdate
				playdateChannel = pusher.subscribe($('#pusher-channel-name').html());
				listenForEndPlaydate();
			}
			else {
				listenForPlaydateRequest();
			}
		}
	);
			
}

//serves up a lightbox with the playdate join request 
function showPlaydateRequest(data) {
	
	//data.id is playdate id. put that in the playdate channel name field
	$("#pusher-channel-name").html(data.pusherChannelName);
	//$('#player-name').html(data.initiator);
	
	var friend_div = 'div.*[data-friendid=' + data.initiatorID + ']'
	
	//$(friend_div + ' p.left a').attr('href', '/playdate?playdate=' + data.playdateID);	
	//$(friend_div + ' a.friend-item').attr('href', '/playdate?playdate=' + data.playdateID);	
	
	$(friend_div + ' p.left a').on(tablet ? 'touchstart' : 'click', function() { 
		syncToServerBeginPlaydate('playdate', data.playdateID, data.initiatorID);
	});
	
	$(friend_div + ' a.friend-item').on(tablet ? 'touchstart' : 'click', function() { 
		syncToServerBeginPlaydate('playdate', data.playdateID, data.initiatorID);
	});	
	
	$(friend_div + ' p.right a').on(tablet ? 'touchstart' : 'click', function() { 
		removePlaydateRequest(data.initiatorID);
		endPlaydate();
	});
	
	$('a.*[data-friendid=' + data.initiatorID + '] img.online').hide('fast');
	$('.overlay').show(500, function() {
		$(friend_div).css("z-index", 1001);
		$(friend_div + ' a.friend-item img.friend-item').addClass('shadow');	
		$(friend_div + ' .friend-image-wrapper').addClass("calling");
		window.setTimeout(function() {
			$(friend_div + ' .call-button').slideDown('fast');
		}, 100, true);
	});
	
}

//removes lightbox with the playdate join request 
function removePlaydateRequest(playmateID) {
	//data.id is playdate id. put that in the playdate channel name field
	$("#pusher-channel-name").html('');
	//$('#player-name').html('');
	//$('#playdate-target').attr('');	
	
	var friend_div = 'div.*[data-friendid=' + playmateID + ']'
	
	$(friend_div).css("z-index", 1);
	$(friend_div + ' .friend-image-wrapper').removeClass("calling");
	$(friend_div + ' .call-button').fadeOut();
	$('.overlay').hide();	
}

function syncToServerBeginPlaydate(paramKey, playdateID, friendID) {
	
	$('.user-profile').fadeOut('medium');
	setPlaymatePhoto(friendID, null);
	animatePhotos();
	$('.appContainer').show();
	
	setTimeout(function() { 
		toggleToyBox(); 
		setTimeout(function() { $('.instructions').fadeIn('fast'); }, 500);
	}, 1000);
	
	//preloader();
	
	var params = paramKey + '=' + (paramKey == 'playdate' ? playdateID : friendID)
	$.ajax({
		url: "/playdate.json",
		data: params,
		type: "POST",
		success: function(data) {
			initPlaydate(data.playdate.pusher_channel_name);	
		}
	});
}

// changes the visual state of a user's friend on the dialpad
// presence can be online, offline, or pressed
function changeUserPresence(user_id, presence) {
	
	$('a.*[data-friendid=' + user_id + '] .presence').hide();
	$('a.*[data-friendid=' + user_id + '] .'+ presence).show();

}

function enableDialpadButtons() {
	
	$('.online').on(tablet ? 'touchstart' : 'mousedown', function() {
		var friendid = $('a').has(this).data("friendid");
		changeUserPresence(friendid, "pressed");
		syncToServerBeginPlaydate("friend_id", null, friendid);
	});
	
	//add friends
	$("#add-friend").on(tablet ? 'touchstart' : 'click', function() {
		$('.friend.add-friend p a').addClass('active');
		$('#find-lightbox').lightbox_me({
	    	centered: true,
			onLoad: function() {
				$('#find-lightbox-text').find('input[type=text]:first').focus();
			},
			onClose: function() {
				$('.friend.add-friend p a').removeClass('active');
			}
		});
	});
	
}

function preloader() {
	if (document.images) {
		var img1 = new Image();
		var img2 = new Image();
		var img3 = new Image();
		var img4 = new Image();

		img1.src = "https://ragatzi.s3.amazonaws.com/thomas-breaks-a-promise-page0.png";
		img2.src = "https://ragatzi.s3.amazonaws.com/little-red-riding-hood-page0.png";
		img3.src = "https://ragatzi.s3.amazonaws.com/this-old-man-page0.png";
		img4.src = "https://ragatzi.s3.amazonaws.com/the-three-bears-page0.png";
	}
}
