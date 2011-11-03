

(function() {
	
	mouse = { x: 0, y: 0 };
	
	page = 0;
	
	flips = [];
	
	book = document.getElementById( "book" );
	
	// List of all the page elements in the DOM
	pages = book.getElementsByTagName( "section" );
	
	// Organize the depth of our pages and create the flip definitions
	for( var i = 0, len = pages.length; i < len; i++ ) {
		pages[i].style.zIndex = len - i;
		
		flips.push( {
			// Current progress of the flip (left -1 to right +1)
			progress: 1,
			// The target value towards which progress is always moving
			target: 1,
			// The page DOM element related to this flip
			page: pages[i], 
			// True while the page is being dragged
			dragging: false
		} );
	}
	
	// Render the page flip 60 times a second
	setInterval( render, 1000 / 60 );
	
	//document.addEventListener( "mousemove", mouseMoveHandler, false );
	//document.addEventListener( "mousedown", mouseDownHandler, false );
	//document.addEventListener( "mouseup", mouseUpHandler, false );
	
	var nextlink = document.getElementById("next-link");
	nextlink.addEventListener("click", function() {
		turnBookPage(page+1);
		syncToServer(page, 101);
		}, false);
	var prevlink = document.getElementById("previous-link");
	prevlink.addEventListener("click", function() {
		turnBookPage(page-1);
		syncToServer(page, 101);
		}, false);
	
})();


