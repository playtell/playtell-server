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
		else { 
			if ($('*[data-friendid=' + parseInt(data.playmateID) + ']').length != 0) {
				changeUserPresence(parseInt(data.playmateID), "disabled");
			}
			if ($('*[data-friendid=' + parseInt(data.initiatorID) + ']').length != 0) {
				changeUserPresence(parseInt(data.initiatorID), "disabled");
			}
		}
	});	

	rendezvousChannel.bind('pusher:subscription_succeeded', function(members){
		members.each(function(member) {
			if ($('*[data-friendid=' + member.id + ']').length != 0) {
				changeUserPresence(member.id, "enabled");
			}
		 });
	})

	rendezvousChannel.bind('pusher:member_removed', function(member){
	    if ($('*[data-friendid=' + member.id + ']').length != 0) {
			changeUserPresence(member.id, "disabled");
		}
  })

  	rendezvousChannel.bind('pusher:member_added', function(member){
		if ($('*[data-friendid=' + member.id + ']').length != 0 && $('*[data-friendid=' + member.id + ']').hasClass("disabled")) {
			changeUserPresence(member.id, "enabled");
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