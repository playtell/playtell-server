function listenForPlaydateRequest() {
	var rendezvousChannel = pusher.subscribe("rendezvous-channel");
	rendezvousChannel.bind('playdate_requested', function(data) {
		console.log(data);
		if (data.otherPlayerID == $('#current-user').html()) {
			showPlaydateRequest(data);
			pusher.unsubscribe("rendezvous-channel");
			playdateChannel = pusher.subscribe($('#pusher-channel-name').html());
			listenForEndPlaydate(false);
		}
	});	
}

//should be listenForChangeActivity
function listenForChangeBook() {
	playdateChannel.bind('change_book', function(data) {
		if (data.player != $('#current-user').html()) {
			hideToyBox();
			var bookData = $.parseJSON(data.data);
			doChangeBook(bookData.book);
		}
	});
}

function listenForTurnPage() {
	playdateChannel.bind('turn_page', function(data) {
		if (data.player != $('#current-user').html())
			turnBookPage(data.page); 
	});
}

function listenForEndPlaydate(in_playdate) {
	playdateChannel.bind('end_playdate', function(data) {
		if (!in_playdate) {
			$('#join-lightbox').trigger('close');
			pusher.unsubscribe("disconnect-channel");
			listenForPlaydateRequest();
		}
		else if (data.player != $('#current-user').html())
			endPlaydate(); 
	});
}