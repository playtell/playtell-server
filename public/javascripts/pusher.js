function listenForPlaydateRequest() {
	var rendezvousChannel = pusher.subscribe("presence-rendezvous-channel");
	//when successfully subscribed
	rendezvousChannel.bind('playdate_requested', function(data) {
		if (parseInt(data.playmateID) == parseInt($('#current-user').html())) {
			showPlaydateRequest(data);
			pusher.unsubscribe("presence-rendezvous-channel");
			playdateChannel = pusher.subscribe($('#pusher-channel-name').html());
			listenForEndPlaydate(false);
		}
		/*else { 
			if ($('*[data-friendid=' + parseInt(data.playmateID) + ']').length != 0) {
				changeUserPresence(parseInt(data.playmateID), "offline");
			}
			if ($('*[data-friendid=' + parseInt(data.initiatorID) + ']').length != 0) {
				changeUserPresence(parseInt(data.initiatorID), "offline");
			}
		}*/
	});	

	rendezvousChannel.bind('pusher:subscription_succeeded', function(members){
		members.each(function(member) {
			if ($('*[data-friendid=' + member.id + ']').length != 0) {
				changeUserPresence(member.id, "online");
			}
		 });
	})

	rendezvousChannel.bind('pusher:member_removed', function(member){
	console.log("member removed: " + member.id);
/*	    if ($('*[data-friendid=' + member.id + ']').length != 0) {
			changeUserPresence(member.id, "offline");
		}
*/  })

  	rendezvousChannel.bind('pusher:member_added', function(member){
		console.log("member added: " + member.id);
		if ($('*[data-friendid=' + member.id + ']').length != 0) {
			changeUserPresence(member.id, "online");
		}
  	})

}

//should be listenForChangeActivity
function listenForChangeBook() {
	playdateChannel.bind('change_book', function(data) {
		if (parseInt(data.player) != parseInt($('#current-user').html())) {
			var bookData = $.parseJSON(data.data);
			resetPlayspace($('*[data-activityid=' + bookData.book.id + ']'));
			doChangeBook(bookData.book);
		}
	});
}

function listenForTurnPage() {
	playdateChannel.bind('turn_page', function(data) {
		if (parseInt(data.player) != parseInt($('#current-user').html())) {
			page = parseInt(data.page);
			mySwipe.slide(parseInt(data.page), 100, true);
		}
	});
}

function listenForFinger() {
	playdateChannel.bind('grandma_finger', function(data) {
		if (parseInt(data.player) != parseInt($('#current-user').html())) {
			$("#finger").offset({ top: data.y, left: data.x }).removeClass('invisible');
			console.log(data.x + ", " + data.y);
			setTimeout(function() { $("#finger").addClass('invisible'); }, 1000);
		}
	});
}

function listenForEndPlaydate() {
	playdateChannel.bind('end_playdate', function(data) {
		if (!inPlaydate) {
			removePlaydateRequest(data.player);
			if (pusher.channel($('#pusher-channel-name'))) {
				pusher.unsubscribe($('#pusher-channel-name').html());
			}
			listenForPlaydateRequest();
		}
		else if (data.player != $('#current-user').html())
			endPlaydate(); 
	});
}