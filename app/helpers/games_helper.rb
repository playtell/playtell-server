module GamesHelper  
  def getPageImageFilePath(title, pageNum)
    File.join(title.parameterize, "page"+pageNum+".png")
  end
  
  def playdateExists()
    return Playdate.first
  end
end

