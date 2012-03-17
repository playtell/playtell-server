function PTBook() {}
PTBook.prototype = new PTActivity();
//PTBook.prototype.constructor = PTBook;

PTBook.prototype.createActivityFromJSON=function(book) {
	var bookMarkup = '';
	var pageNum = 0;
	var displayType = "block";

	$.each(book.pages, function(i, page) {
		pageNum = i;
		if (pageNum > 1) {
			displayType = "none";
		}
		if (pageNum == 0) {
			bookMarkup += '<li style=display:' + displayType + '>'
			 	+ '<div id="page_' + pageNum + '" class="page">'
				+ '</div>'
				+ '<div class="title-page"><img src="' + getPageImageFilePath(book.image_directory, pageNum) + '" class="title-image"></div></li>';
		}
		else {
			bookMarkup += '<li style=display:' + displayType + '>'
			 	+ '<div id="page_' + pageNum + '" class="page">'
				+ '<div class="inline-block">'
				+ '<img src="' + getPageImageFilePath(book.image_directory, i+1) + '" class="book-image">'
				+ '<div class="inline-block fl bottom-shadow">'
				+ '<img src="/images/photo_frame_left.png">'
				+ '</div>'
				+ '<div class="inline-block fr bottom-shadow">'
				+ '<img src="/images/photo_frame_right.png">'
				+ '</div>'
				+ '</div>'
				+ '<div class="book-text">' 
				+ book.pages[i].page_text 
				+ '</div></div></li>';
		}
	});
	$('#pages').html("<ul>" + bookMarkup + "</ul>");
}
