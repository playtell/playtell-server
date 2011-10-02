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
	   	},
		playerVars: {
		 'origin': 'www.ragatzi.com'
		}
 	});
}

// The API will call this function when the video player is ready.
function onPlayerReady(event) {
 //event.target.playVideo();
}

var playerTimeChecker;
var playerTimeSetter;

//http://code.google.com/apis/youtube/js_api_reference.html
function onPlayerStateChange(event) {
	if (event.data == 1) { //playing
		$.get("/update_page.js?playdateChange=301");
      	session.signal();
		playerTimeSetter = setInterval("sendTime()", 5000);
		playerTimeChecker = setInterval("checkTime()", 9000);
    }
	else if (event.data == 2 || event.data == 3) { //paused or buffering
		$.get("/update_page.js?playdateChange=302");
      	session.signal();
		clearInterval(playerTimeSetter);
		clearInterval(playerTimeChecker);
    }
	else if (event.data == 0) { //ended
		clearInterval(playerTimeSetter);
		clearInterval(playerTimeChecker);
    }
}

function stopVideo() {
 player.stopVideo();
}

function sendTime() {
	t = player.getCurrentTime();
	$.post("/set_time.js?currentTime="+t);
}

function checkTime () {
	$.get("/check_time.js");
}