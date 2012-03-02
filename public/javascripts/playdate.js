function doChangeBook(book) {
	$('#keepsake-container').hide();
	if ($('.instructions').is(":visible")) { $('.instructions').fadeOut('fast'); }
	enableNavButtons("book", 101);
	$('#total-pages').html(book.pages.length);
	$('#page-num').html(1);
	$('.book-nav').show();
	b = new PTBook();
	page = 0;
	b.createActivityFromJSON(book);
	mySwipe = new Swipe(
	  document.getElementById('pages'), {
		speed: 100, 
		callback: function() {
			console.log("in callback. responder is: " + mySwipe.getResponder());
			if (!mySwipe.getResponder()) {
				console.log("pushing");
				page = mySwipe.getPos();
				syncToServerNoData(101);
			}
		}
	  }
	);
	$('.loading').hide();
	$('.book-container').show();
	mySwipe.setup();
	listenForTurnPage();
	
	//grandma finger
	//listenForTap(); <-- not yet built
	$('#book').on(tablet ? 'touchstart' : 'click', function(e) {
		$("#finger").offset({ top: e.pageY, left: e.pageX}).show();
	});
}

//disable book nav links as appropriate
function updateBookNavLinks(currentPage) {
	if (page == 1) {
		hideButton("previous-link");
		showButton("next-link");
	}
	else if (page > 1) {
		showButton("previous-link");
		if (page >= parseInt($("#total-pages").html())) {
			hideButton("next-link");
		}
		else if (page < parseInt($("#total-pages").html())) {
			showButton("next-link");
		}
	}
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

function disableNavButtons() {
	$("#next-link").die("click");
	$("#previous-link").die("click");
}

function enableNavButtons(activity, playdateChange) {
	disableNavButtons();
	if (activity == "book") {
		$("#next-link").live("click", function n(e) {
			page++;
			console.log("click to page:" + page);
		    //turnBookPage(page+1); //page var gets updated in this fn call
		    syncToServerNoData(playdateChange);
			mySwipe.next();
			return false;
	    });

		$("#previous-link").live("click", function p(e) {
			page--;
		    //turnBookPage(page-1); //page var gets updated in this fn call
		    syncToServerNoData(playdateChange);
			mySwipe.prev();
			return false;
	    });
	}
	else {
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
	}
}

function enableToySelectors() {
	$('.content-item').on(tablet ? 'touchstart' : 'click', function() {
		resetSelectedContentItem(this);
		if ($('.instructions').is(":visible")) { $('.instructions').fadeOut('fast'); }
		$('.book-container').hide();
		hideToyBox();
		$('.loading').show();
		syncToServerReturnData(this.getAttribute('data-playdatechange'), this.getAttribute('data-activityid'));
	});
}

function resetSelectedContentItem(element) {
	$('.selected-indicator').hide();
	$('.content-item').removeClass("selected-content-item");
	
	var newPos = $(element).position().top + $(element).outerHeight()/2 - 5;
	$('.selected-indicator').css("top", newPos);
	$(element).addClass("selected-content-item");
	$('.selected-indicator').show();
}

function enableButtons() {

	$('#toybox-link').on(tablet ? 'touchstart' : 'click', function() {
		toggleToyBox();
	});

	$('#disconnect-link').on(tablet ? 'touchstart' : 'click', function() {
		endPlaydate();
	});

}

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
				$('.book-container').hide();
				enableNavButtons("keepsake", 501);
				$('#total-pages').html(num_keepsakes.toString()); 
				$('#page-num').html(1);
				$('.keepsake').removeAttr("style");
				$('#keepsake-container').show();
				goToPage(1, "keepsake"); 
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

function syncToServerBeginPlaydate(friend_id) {
	$("#friend_"+ friend_id).attr({
		method: "POST",
		action: "/playdate?friend_id=" + friend_id
	});
	console.log($("#friend_"+ friend_id));
	$("#friend_"+ friend_id).submit();
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
	$('#player-name').html(data.initiator);
	$('#playdate-target').attr('href', '/playdate?playdate=' + data.playdateID);
	$('#join-lightbox').lightbox_me({
	    centered: true, 
		onClose: function() { $('#join-lightbox').empty(); }
	});	
}

// changes the visual state of a user's friend on the dialpad
// presence can be online, offline, or pressed
function changeUserPresence(user_id, presence) {
	$('*[data-friendid=' + user_id + '] .presence').hide();
	$('*[data-friendid=' + user_id + '] .'+ presence).show();
}

function enableDialpadButtons() {
	$('.online').on(tablet ? 'touchstart' : 'mousedown', function() {
		var friendid = $('a').has(this).data("friendid");
		changeUserPresence(friendid, "pressed");
		syncToServerBeginPlaydate(friendid);
		//<%= playdate_path :friend_id => friend.id %>
		//syncToServerBeginPlaydate(this.getAttribute('data-playdatechange'), this.getAttribute('data-activityid'));
	});
	
	//add friends
	$("#add-friend").on(tablet ? 'touchstart' : 'click', function() {
		$('#find-lightbox').lightbox_me({
	    	centered: true,
			onLoad: function() {
				$('#find-lightbox-text').find('input[type=text]:first').focus();
			}
		});
	});
	
}