// This code loads the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "http://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubePlayerAPIReady() {
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

// The API will call this function when the video player is ready.
function onPlayerReady(event) {
 //event.target.playVideo();
}

//http://code.google.com/apis/youtube/js_api_reference.html
function onPlayerStateChange(event) {
	if (event.data == 1) { //playing
		$.get("/update_page.js?playdateChange=301");
      	session.signal();
    }
	else if (event.data == 2) { //paused
		$.get("/update_page.js?playdateChange=302");
      	session.signal();
    }
}

function stopVideo() {
 player.stopVideo();
}
