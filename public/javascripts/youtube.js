// 2. This code loads the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "http://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// 3. This function creates an <iframe> (and YouTube player)
//    after the API code downloads.
var player;
function onYouTubePlayerAPIReady() {
	//createPlayer();
}

function createPlayer() {
	var parentDiv = document.getElementById('player-container');
	var div = document.createElement('div');			
	div.setAttribute('id', 'player');
	parentDiv.appendChild(div);
	
	player = new YT.Player('player', {
    	height: '390',
	    width: '640',
	    videoId: 'Mh85R-S-dh8',
	    events: {
	     'onReady': onPlayerReady,
	     'onStateChange': onPlayerStateChange
	   	}

 	});
}

// 4. The API will call this function when the video player is ready.
function onPlayerReady(event) {
 //event.target.playVideo();
}

// 5. The API calls this function when the player's state changes.
//    The function indicates that when playing a video (state=1),
//    the player should play for six seconds and then stop.
function onPlayerStateChange(event) {
	if (event.data == YT.PlayerState.PLAYING) {
		$.get("/update_page.js?playdateChange=301");
      	session.signal();
    }
}

function stopVideo() {
 player.stopVideo();
}
