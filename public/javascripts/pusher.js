function listenForPlaydateRequest() {
	requestChannel.bind('playdate_requested', function(data) {
		if (data.otherPlayerID == $('#current-user').html()) {
			joinPlaydateLightbox(data);
			pusher.unsubscribe("request-channel");
			//listenForEndPlaydate();
		}
	});	
}

//should be listenForChangeActivity
function listenForChangeBook() {
	thingChannel.bind('change_book', function(data) {
		if (data.player != $('#current-user').html()) {
			hideToyBox();
			var thingBook = $.parseJSON(data.data);
			doChangeBook(thingBook.book);
		}
	});
}

function listenForTurnPage() {
	thingChannel.bind('turn_page', function(data) {
		if (data.player != $('#current-user').html())
			turnBookPage(data.page); 
	});
}

function listenForEndPlaydate() {
	thingChannel.bind('end_playdate', function(data) {
		if (data.player != $('#current-user').html())
			endPlaydate(); 
	});
}