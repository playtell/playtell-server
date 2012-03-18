function initPlaydate() {
	
	pusher = new Pusher($('#pusher-key').html()); 
	playdateChannel = pusher.subscribe($('#pusher-channel-name').html());
	listenForEndPlaydate(true);
	
	enableButtons();
	enableToySelectors();
	toggleToyBox();
	
	$('.instructions').fadeIn('slow');
	
	listenForChangeBook();
	
}

function endPlaydate() {
	pusher.unsubscribe($("#pusher-channel-name").html()); //disconnect on pusher
	$.get("/disconnect_playdate"); //disconnect on playtell 
	
	// prompt for feedback:
	$('#feedback-lightbox').lightbox_me({
	    centered: true, 
		closeClick: false,
		onClose: function () {
			document.location.href='/users/' + $('#current-user').html();
		}
	});
}

function enableButtons() {

	$('#toybox-link').on(tablet ? 'touchstart' : 'click', function() {
		toggleToyBox();
	});

	/*$('#disconnect-link').on(tablet ? 'touchstart' : 'click', function() {
		endPlaydate();
	});*/

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
	$('.book-nav').hide();

	$('.loading').show();

}

function doChangeBook(book) {	
	$('#total-pages').html(book.pages.length);
	$('#page-num').html(1);
	
	b = new PTBook();
	page = 0;
	b.createActivityFromJSON(book);
	mySwipe = new Swipe(
	  document.getElementById('pages'), {
		speed: 100, 
		callback: function() {
			updateBookNavLinks()
			if (!mySwipe.getResponder()) {
				//page = mySwipe.getPos();
				syncToServerNoData(101);
			}
		}
	  }
	);
	
	$('.loading').hide();
	
	enableNavButtons("book", 101);
	updateBookNavLinks()
	$('.book-nav').show();
	
	$('.book-container').show();
	mySwipe.setup();
	listenForTurnPage();
	
	//grandma finger
	//listenForTap(); <-- not yet built
	//$('#book').on(tablet ? 'touchstart' : 'click', function(e) {
	//	$("#finger").offset({ top: e.pageY, left: e.pageX}).show();
	//});
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
		}
		else if (page < mySwipe.getLength()-1) {
			$("#next-link").removeClass("disabled");
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
	    syncToServerNoData(playdateChange);
		mySwipe.next();
		return false;
    });

	$("#previous-link").live("click", function p(e) {
		page--;
	    syncToServerNoData(playdateChange);
		mySwipe.prev();
		return false;
    });

}

//used for changing activity. 
//sends payload of current playdate state to server, then updates playspace with callback data
function syncToServerReturnData(playdate_change, activityID) {
	
	$.getJSON(
		"/update_playdate", 
		{ 
			playdateChange: playdate_change, 
		  	activityID: activityID 
		},		
		function(data) {
			if (data.book) {
				doChangeBook(data.book);
			}
			else {
				doTurnOnCamera();
			}
		}
	);
	
}

//used for in-activity changes like turn page
//sends payload of current playdate state to server
function syncToServerNoData(playdate_change) {
	
	$.ajax({
		url: "/update_playdate.js",
		data: "playdateChange=" + playdate_change + "&newPage=" + page,
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
	
	console.log($('div.*[data-friendid=' + data.initiatorID + '] p.left a').attr("href"));
	var friend_div = 'div.*[data-friendid=' + data.initiatorID + ']'
	
	$(friend_div + ' p.left a').attr('href', '/playdate?playdate=' + data.playdateID);	
	$(friend_div + ' a.friend-item').attr('href', '/playdate?playdate=' + data.playdateID);	
	$(friend_div + ' p.right a').on(tablet ? 'touchstart' : 'click', function() { 
		console.log("removing" + data.initiatorID);
		removePlaydateRequest(data.initiatorID);
		endPlaydate();
	});
	
	$('a.*[data-friendid=' + data.initiatorID + '] img.online').hide('fast');
	$('.overlay').show(500, function() {
		$(friend_div).css("z-index", 1001);
		$(friend_div + ' .friend-image-wrapper').addClass("calling");
		window.setTimeout(function() {
			$(friend_div + ' .call-button').fadeIn('fast');
		}, 100, true);
	});
	
}

//serves up a lightbox with the playdate join request 
function removePlaydateRequest(playmateID) {
	//data.id is playdate id. put that in the playdate channel name field
	$("#pusher-channel-name").html('');
	$('#player-name').html('');
	$('#playdate-target').attr('');	
	
	var friend_div = 'div.*[data-friendid=' + playmateID + ']'
	
	$(friend_div).css("z-index", 1);
	$(friend_div + ' .friend-image-wrapper').removeClass("calling");
	$(friend_div + ' .call-button').fadeOut();
	$('.overlay').hide();	
}

function syncToServerBeginPlaydate(friend_id) {
	
	document.location.href="/playdate?friend_id=" + friend_id;
	
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
		syncToServerBeginPlaydate(friendid);
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