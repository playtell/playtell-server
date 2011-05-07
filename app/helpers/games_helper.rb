module GamesHelper  
  def getPageImageFilePath(title, pageNum)
    File.join(title.parameterize, "page"+pageNum+".png")
  end
end

