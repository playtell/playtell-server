function PTBook() {}
PTBook.prototype = new PTActivity();
//PTBook.prototype.constructor = PTBook;

PTBook.prototype.createActivityFromJSON=function(book) {
	var bookMarkup = '';
	
	$.each(book.pages, function(i, page) {
		bookMarkup += '<li style=display:none>'
			+ '<div id="page_' + i+1 + '" class="page">'
			+ '<div class="inline-block">'
			+ '<img src="' + getPageImageFilePath(book.image_directory, i+1) 
			+ '" class="book-image'; 
		if (book.image_only) { 
			bookMarkup += ' book-image-only';
		}
		bookMarkup += '">'
			+ '<div class="inline-block fl bottom-shadow">'
			+ '<img src="/images/photo_frame_left.png">'
			+ '</div>'
			+ '<div class="inline-block fr bottom-shadow">'
			+ '<img src="/images/photo_frame_right.png">'
			+ '</div>'
			+ '</div>';
		if (!book.image_only) {
			if (book.pages[i].page_text.length > 400) {
				bookMarkup += '<div class="book-text-small">';
			}
			else {
				bookMarkup += '<div class="book-text">';	
			} 
			bookMarkup += book.pages[i].page_text 
							+ '</div>';
		}
		bookMarkup += '</div></li>';
	});
	
	$('#pages-' + book.id).addClass('full');
	//$('#pages').html("<ul>" + bookMarkup + "</ul>");
	$('ul.*[data-bookID=' + book.id + ']').append(bookMarkup); 
}
