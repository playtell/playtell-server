function PTBook() {}
PTBook.prototype = new PTActivity();
//PTBook.prototype.constructor = PTBook;

PTBook.prototype.createActivityFromJSON=function(book) {
	var bookMarkup = '';
	var pageNum = 0;
	var displayType = "block";

	$.each(book.pages, function(i, page) {
		pageNum = i+1;
		if (pageNum > 1) {
			displayType = "none";
		}
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
			+ '</div></div>';
		if (pageNum == 1) {
			bookMarkup += '<div class="title-page"><img src="/images/book_title_cover.png"></div>';
		}
		bookMarkup += '</li>';
	});
	$('#pages').html("<ul>" + bookMarkup + "</ul>");
}
