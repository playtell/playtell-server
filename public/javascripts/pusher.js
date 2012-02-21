function listenForPlaydateRequest() {
	var rendezvousChannel = pusher.subscribe("presence-rendezvous-channel");
	//when successfully subscribed
	rendezvousChannel.bind('playdate_requested', function(data) {
		if (data.otherPlayerID == $('#current-user').html()) {
			showPlaydateRequest(data);
			pusher.unsubscribe("presence-rendezvous-channel");
			playdateChannel = pusher.subscribe($('#pusher-channel-name').html());
			listenForEndPlaydate(false);
		}
	});	

	rendezvousChannel.bind('pusher:subscription_succeeded', function(members){
		members.each(function(member) {
			if ($('*[data-friendid=' + member.id + ']').length != 0) {
				$('*[data-friendid=' + member.id + ']').removeClass("offline");
				$('*[data-friendid=' + member.id + ']').addClass("online");
			}
		  });
	})
	
	rendezvousChannel.bind('pusher:member_removed', function(member){
	    if ($('*[data-friendid=' + member.id + ']').length != 0) {
			$('*[data-friendid=' + member.id + ']').removeClass("online");
			$('*[data-friendid=' + member.id + ']').addClass("offline");
		}
  })

  	rendezvousChannel.bind('pusher:member_added', function(member){
	    if ($('*[data-friendid=' + member.id + ']').length != 0) {
			$('*[data-friendid=' + member.id + ']').removeClass("offline");
			$('*[data-friendid=' + member.id + ']').addClass("online");
		}
  })
}

//should be listenForChangeActivity
function listenForChangeBook() {
	playdateChannel.bind('change_book', function(data) {
		if (parseInt(data.player) != parseInt($('#current-user').html())) {
			hideToyBox();
			var bookData = $.parseJSON(data.data);
			doChangeBook(bookData.book);
		}
	});
}

function listenForTurnPage() {
	playdateChannel.bind('turn_page', function(data) {
		if (parseInt(data.player) != parseInt($('#current-user').html())) {
			//turnBookPage(data.page); 
			console.log("responding from player: " + data.player + ". page turning to: " + parseInt(data.page));
			page = parseInt(data.page);
			mySwipe.slide(parseInt(data.page), 100, true);
		}
		else {
			console.log("(ignoring) heard trigger from player: " + data.player + " for: " + parseInt(data.page));
		}
	});
}

function listenForEndPlaydate(in_playdate) {
	playdateChannel.bind('end_playdate', function(data) {
		if (!in_playdate) {
			$('#join-lightbox').trigger('close');
			pusher.unsubscribe($('#pusher-channel-name').html());
			listenForPlaydateRequest();
		}
		else if (data.player != $('#current-user').html())
			endPlaydate(); 
	});
}