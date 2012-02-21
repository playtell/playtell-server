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
		bookMarkup += '<li style=display:' + displayType + '><div id="page_' + pageNum + '"> <div class="book-image"><img src="' + getPageImageFilePath(book.image_directory, i+1) + '"></div> <div class="book-text">' + book.pages[i].page_text + '</div></div></li>';
	});
	$('#pages').html("<ul>" + bookMarkup + "</ul>");
}
