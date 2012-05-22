function PTBook() {}
PTBook.prototype = new PTActivity();
//PTBook.prototype.constructor = PTBook;

PTBook.prototype.createActivityFromJSON=function(book) {
	var bookMarkup = '', pageNum;
	$.each(book.pages, function(i, page) {
		pageNum = i+1;
			bookMarkup += '<li>' 
				+ '<div id="page_' + pageNum + '" class="page">';
				bookMarkup += '<div class="inline-block">'
				+ '<img src="' + getPageImageFilePath(book.image_directory, pageNum) 
				+ '" class="book-image'; 
				if (book.image_only) { 
					bookMarkup += ' book-image-only';
				}
				bookMarkup += '">';
				bookMarkup += '<div class="inline-block fl bottom-shadow">'
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
	$('ul.*[data-bookID=' + book.id + ']').append(bookMarkup); 
}
