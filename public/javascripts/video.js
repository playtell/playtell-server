// OPENTOK
//--------------------------------------
//  LINK CLICK HANDLERS
//--------------------------------------

/* 
If testing the app from the desktop, be sure to check the Flash Player Global Security setting
to allow the page from communicating with SWF content loaded from the web. For more information,
see http://www.tokbox.com/opentok/build/tutorials/basictutorial.html#localTest
*/
function connect() {
	session.connect(apiKey, token);
}

function disconnect() {
	if (!inSetup) {
		session.signal();
	}
	session.disconnect();
}

function publish(location, width, height, name) {
	if (!publisher) {
		var parentDiv = document.getElementById(location);
		var div = document.createElement('div');			// Create a replacement div for the publisher
		div.setAttribute('id', 'opentok_publisher');
		parentDiv.appendChild(div);
		$('#'+location).removeClass('loading');
		var publisherProps = {width: width, height: height, name: name, microphoneEnabled: true};
		publisher = session.publish('opentok_publisher', publisherProps); 	// Pass the replacement div id to the publish method
		//show('unpublish-link');
		//hide('publish-link');
	}
}

function unpublish() {
	if (publisher) {
		session.unpublish(publisher);
	}
	publisher = null;

	//show('publish-link');
	//hide('unpublish-link');
}

function subscribeAndPublish(publisherDiv, pubWidth, pubHeight, pubName) {

	// Subscribe to all streams currently in the Session
	for (var i = 0; i < event.streams.length; i++) {
		addStream(event.streams[i]);
	}
	
	publish(publisherDiv, pubWidth, pubHeight, pubName);				
}

function turnOnKeepsakeCameras() {
	session.cleanup();
	publisher = null;
	publish('myCam-keepsake', KEEPSAKE_WIDTH, KEEPSAKE_HEIGHT, 'keepsake');
}

function takeSnapshot() {
	var pubImgData = publisher.getImgData();
	var subImgData; 
	var subImg;
		
	var pubImg = document.createElement("img");
	pubImg.setAttribute("src", "data:image/png;base64," + pubImgData);	
	
	if (subscribers[0]) {
		subImgData = subscribers[0].getImgData();	
		subImg = document.createElement("img");
		subImg.setAttribute("src", "data:image/png;base64," + subImgData);
	}
	
	var imgWin = window.open("about:blank", "Screenshot");
	imgWin.document.write("<body></body>");
	imgWin.document.body.appendChild(pubImg);
	if (subscribers[0]) {
		imgWin.document.body.appendChild(subImg);
	}
}

//--------------------------------------
//  OPENTOK EVENT HANDLERS
//--------------------------------------

function sessionConnectedHandler(event) {
	for (var i = 0; i < event.streams.length; i++) {
		addStream(event.streams[i]);
	}
	publish("my-camera", PUBLISHER_WIDTH, PUBLISHER_HEIGHT, "");
	//listen for device status event
	//deviceManager = TB.initDeviceManager(apiKey);
	//deviceManager.addEventListener("devicesDetected", devicesDetectedHandler);
	//deviceManager.detectDevices();
}

function devicesDetectedHandler(event) {
	if (inSetup) {
		if (event.selectedCamera) {
			if (event.selectedCamera.status	== "unknown") {
				inSetup = true;
				$("#setup").removeClass("hidden");
				deviceManager.removeEventListener("devicesDetected", function(){});
				publish("setup", PUBLISHER_WIDTH, PUBLISHER_HEIGHT);
				publisher.addEventListener("accessAllowed", accessAllowedHandler);
			}
			//else {
				//inSetup = false;
			//	publish("my-camera");
			//}				
		}
	}
}

function accessAllowedHandler(event) {
	publisher.removeEventListener("accessAllowed", function(){});
	$("#setup").html("success!");
	$("#setup").addClass("hidden");
	unpublish();
	publish("my-camera", PUBLISHER_WIDTH, PUBLISHER_HEIGHT, "");
}

function streamCreatedHandler(event) {
	// Subscribe to these newly created streams
	for (var i = 0; i < event.streams.length; i++) {
		addStream(event.streams[i]);
	}
}

function streamDestroyedHandler(event) {
	// This signals that a stream was destroyed. Any Subscribers will automatically be removed. 
	// This default behaviour can be prevented using event.preventDefault()
}

function sessionDisconnectedHandler(event) {
	// This signals that the user was disconnected from the Session. Any subscribers and publishers
	// will automatically be removed. This default behaviour can be prevented using event.preventDefault()
	publisher = null;
}

function connectionDestroyedHandler(event) {
	// This signals that connections were destroyed
}

function connectionCreatedHandler(event) {
	// This signals new connections have been created (ie another person has joined the session)
}

/* 
If you un-comment the call to TB.setEventLister(), above, OpenTok 
calls the exceptionHandler() method when exception events occur. 
You can modify this method to further process exception events.
If you un-comment the call to TB.setLogLevel(), above, OpenTok 
automatically displays exception event messages. 
*/
function exceptionHandler(event) {
	alert("Exception: " + event.code + "::" + event.message);
}

function signalReceivedHandler (event) {
	if (event.fromConnection.connectionId != session.connection.connectionId) {
		$.get("/update_from_playdate.js?title=" + $('#book-title').val() + "&current_page=" + $('#page-num').html());
	}
}


//--------------------------------------
//  HELPER METHODS
//--------------------------------------

function addStream(stream) {
	// Check if this is the stream that I am publishing. If not
	// we choose to subscribe to the stream.
	if (stream.connection.connectionId == session.connection.connectionId) {
//		if (inSetup) {
//			$("#setup").html("success!");
//			$("#setup").addClass("hidden");
//			unpublish();
//			publish("my-camera");
//			return;
//		}
//		else {
//			return;
//		}
		return;
	}
	var parentDiv; 
	var subscriberProps;

	if (stream.name == 'keepsake') {
		parentDiv =  document.getElementById('famCam-keepsake');
		subscriberProps = {width: KEEPSAKE_WIDTH, height: KEEPSAKE_HEIGHT, microphoneEnabled: true};
	}
	else {
		parentDiv = document.getElementById("fam-camera-holder");
		subscriberProps = {width: SUBSCRIBER_WIDTH, height: SUBSCRIBER_HEIGHT, microphoneEnabled: true};
	}
	
	var div = document.createElement('div');	// Create a replacement div for the subscriber
	var divId = stream.streamId;	// Give the replacement div the id of the stream as its id
	div.setAttribute('id', divId);			
	parentDiv.appendChild(div);
	subscribers[0] = session.subscribe(stream, divId, subscriberProps);
}